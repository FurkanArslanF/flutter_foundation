import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

class DriftStorage {
  DriftStorage._();
  static final instance = DriftStorage._();

  static const String _cacheTable = 'kv_cache';
  static const String _queueTable = 'sync_queue';

  _OfflineDatabase? _db;
  Completer<void>? _initCompleter;

  Future<void> initialize() async {
    if (_db != null) {
      return;
    }

    if (_initCompleter != null) {
      return _initCompleter!.future;
    }

    _initCompleter = Completer<void>();

    try {
      final supportDir = await getApplicationSupportDirectory();
      final dbFile = File('${supportDir.path}/flutter_app_foundation_offline.sqlite');
      final executor = NativeDatabase.createInBackground(dbFile);
      _db = _OfflineDatabase(executor);

      await _createSchema();
      _initCompleter!.complete();
    } catch (e, st) {
      _initCompleter!.completeError(e, st);
      rethrow;
    }
  }

  Future<void> _createSchema() async {
    await _db!.customStatement('''
			CREATE TABLE IF NOT EXISTS $_cacheTable (
				cache_key TEXT PRIMARY KEY,
				cache_value TEXT NOT NULL,
				expires_at INTEGER,
				updated_at INTEGER NOT NULL
			)
		''');

    await _db!.customStatement('''
			CREATE TABLE IF NOT EXISTS $_queueTable (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				request_key TEXT,
				endpoint TEXT NOT NULL,
				method TEXT NOT NULL,
				payload TEXT,
				headers TEXT,
				retry_count INTEGER NOT NULL DEFAULT 0,
				last_error TEXT,
				status TEXT NOT NULL DEFAULT 'pending',
				created_at INTEGER NOT NULL,
				updated_at INTEGER NOT NULL
			)
		''');

    await _db!.customStatement('CREATE INDEX IF NOT EXISTS idx_sync_queue_status_created ON $_queueTable(status, created_at)');
  }

  Future<void> _ensureInitialized() async {
    await initialize();
  }

  Future<void> writeData(String key, String value, {Duration? ttl}) async {
    await _ensureInitialized();

    final now = DateTime.now().millisecondsSinceEpoch;
    final expiresAt = ttl == null ? null : now + ttl.inMilliseconds;

    await _db!.customStatement(
      '''
			INSERT INTO $_cacheTable (cache_key, cache_value, expires_at, updated_at)
			VALUES (?, ?, ?, ?)
			ON CONFLICT(cache_key) DO UPDATE SET
				cache_value = excluded.cache_value,
				expires_at = excluded.expires_at,
				updated_at = excluded.updated_at
			''',
      [key, value, expiresAt, now],
    );
  }

  Future<String?> readData(String key) async {
    await _ensureInitialized();

    final result = await _db!.customSelect('SELECT cache_value, expires_at FROM $_cacheTable WHERE cache_key = ?', variables: [Variable.withString(key)]).getSingleOrNull();

    if (result == null) {
      return null;
    }

    final expiresAt = result.data['expires_at'] as int?;
    if (expiresAt != null && expiresAt < DateTime.now().millisecondsSinceEpoch) {
      await deleteData(key: key);
      return null;
    }

    return result.data['cache_value'] as String?;
  }

  Future<void> deleteData({String? key}) async {
    await _ensureInitialized();

    if (key == null) {
      await _db!.customStatement('DELETE FROM $_cacheTable');
      return;
    }

    await _db!.customStatement('DELETE FROM $_cacheTable WHERE cache_key = ?', [key]);
  }

  Future<void> cleanupExpiredCache() async {
    await _ensureInitialized();
    await _db!.customStatement('DELETE FROM $_cacheTable WHERE expires_at IS NOT NULL AND expires_at < ?', [DateTime.now().millisecondsSinceEpoch]);
  }

  Future<void> writeBool(String key, bool value, {Duration? ttl}) async {
    await writeData(key, value.toString(), ttl: ttl);
  }

  Future<bool?> readBool(String key) async {
    final value = await readData(key);
    if (value == null) {
      return null;
    }
    if (value.toLowerCase() == 'true') {
      return true;
    }
    if (value.toLowerCase() == 'false') {
      return false;
    }
    return null;
  }

  Future<void> writeInt(String key, int value, {Duration? ttl}) async {
    await writeData(key, value.toString(), ttl: ttl);
  }

  Future<int?> readInt(String key) async {
    final value = await readData(key);
    if (value == null) {
      return null;
    }
    return int.tryParse(value);
  }

  Future<void> writeDouble(String key, double value, {Duration? ttl}) async {
    await writeData(key, value.toString(), ttl: ttl);
  }

  Future<double?> readDouble(String key) async {
    final value = await readData(key);
    if (value == null) {
      return null;
    }
    return double.tryParse(value);
  }

  Future<void> writeListData(String key, List<dynamic> value, {Duration? ttl}) async {
    await writeData(key, jsonEncode(value), ttl: ttl);
  }

  Future<List<dynamic>> readListData(String key) async {
    final value = await readData(key);
    if (value == null || value.isEmpty) {
      return [];
    }

    try {
      return jsonDecode(value) as List<dynamic>;
    } catch (_) {
      return [];
    }
  }

  Future<void> writeMapData(String key, Map<String, dynamic> value, {Duration? ttl}) async {
    await writeData(key, jsonEncode(value), ttl: ttl);
  }

  Future<Map<String, dynamic>> readMapData(String key) async {
    final value = await readData(key);
    if (value == null || value.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      return Map<String, dynamic>.from(jsonDecode(value) as Map);
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Future<int> enqueueRequest({required String endpoint, required String method, Map<String, dynamic>? payload, Map<String, String>? headers, String? requestKey}) async {
    await _ensureInitialized();

    final now = DateTime.now().millisecondsSinceEpoch;
    await _db!.customStatement(
      '''
			INSERT INTO $_queueTable
			(request_key, endpoint, method, payload, headers, retry_count, last_error, status, created_at, updated_at)
			VALUES (?, ?, ?, ?, ?, 0, NULL, 'pending', ?, ?)
			''',
      [requestKey, endpoint, method.toUpperCase(), if (payload == null) null else jsonEncode(payload), if (headers == null) null else jsonEncode(headers), now, now],
    );

    final idRow = await _db!.customSelect('SELECT last_insert_rowid() AS id').getSingle();
    return idRow.read<int>('id');
  }

  Future<List<Future<OfflineRequest>>> getPendingRequests({int limit = 50}) async {
    await _ensureInitialized();

    final rows = await _db!
        .customSelect(
          '''
					SELECT * FROM $_queueTable
					WHERE status = 'pending'
					ORDER BY created_at ASC
					LIMIT ?
					''',
          variables: [Variable.withInt(limit)],
        )
        .get();

    return rows.map(OfflineRequest.fromRow).toList();
  }

  Future<void> markRequestSynced(int id) async {
    await _ensureInitialized();
    await _db!.customStatement('UPDATE $_queueTable SET status = ?, updated_at = ? WHERE id = ?', ['synced', DateTime.now().millisecondsSinceEpoch, id]);
  }

  Future<void> markRequestFailed(int id, {String? lastError}) async {
    await _ensureInitialized();
    await _db!.customStatement(
      '''
			UPDATE $_queueTable
			SET retry_count = retry_count + 1,
				last_error = ?,
				updated_at = ?
			WHERE id = ?
			''',
      [lastError, DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  Future<void> deleteSyncedRequests({Duration? olderThan}) async {
    await _ensureInitialized();

    if (olderThan == null) {
      await _db!.customStatement('DELETE FROM $_queueTable WHERE status = ?', ['synced']);
      return;
    }

    final threshold = DateTime.now().millisecondsSinceEpoch - olderThan.inMilliseconds;
    await _db!.customStatement('DELETE FROM $_queueTable WHERE status = ? AND updated_at < ?', ['synced', threshold]);
  }

  Future<void> clearQueue() async {
    await _ensureInitialized();
    await _db!.customStatement('DELETE FROM $_queueTable');
  }

  Future<void> close() async {
    final db = _db;
    _db = null;
    _initCompleter = null;
    await db?.close();
  }
}

class OfflineRequest {
  const OfflineRequest({required this.id, required this.endpoint, required this.method, required this.retryCount, required this.status, required this.createdAt, required this.updatedAt, this.requestKey, this.lastError, this.payload, this.headers});

  final int id;
  final String? requestKey;
  final String endpoint;
  final String method;
  final Map<String, dynamic>? payload;
  final Map<String, String>? headers;
  final int retryCount;
  final String? lastError;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  static Future<OfflineRequest> fromRow(QueryRow row) async {
    final payloadRaw = row.read<String?>('payload');
    final headersRaw = row.read<String?>('headers');

    return OfflineRequest(
      id: row.read<int>('id'),
      requestKey: row.read<String?>('request_key'),
      endpoint: row.read<String>('endpoint'),
      method: row.read<String>('method'),
      payload: payloadRaw == null ? null : Map<String, dynamic>.from(jsonDecode(payloadRaw) as Map),
      headers: headersRaw == null ? null : Map<String, String>.from(jsonDecode(headersRaw) as Map),
      retryCount: row.read<int>('retry_count'),
      lastError: row.read<String?>('last_error'),
      status: row.read<String>('status'),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.read<int>('created_at')),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.read<int>('updated_at')),
    );
  }
}

class _OfflineDatabase extends GeneratedDatabase {
  _OfflineDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => const [];
}
