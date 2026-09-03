import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Gizlenmesi gereken verileri güvenli bir şekilde saklamak için kullanılan sınıf
class SecureStorage {
  SecureStorage._();
  static final instance = SecureStorage._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    return _storage.read(key: key);
  }

  Future<void> deleteSecureData({String? key}) async {
    if (key != null) {
      await _storage.delete(key: key);
    } else {
      await _storage.deleteAll();
    }
  }

  Future<void> allDeleteSecureData({String? key}) async {
    await deleteSecureData(key: key);
  }

  Future<void> writeBoolSecureData(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());
  }

  Future<bool?> readBoolSecureData(String key) async {
    final value = await _storage.read(key: key);
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

  Future<void> writeIntSecureData(String key, int value) async {
    await _storage.write(key: key, value: value.toString());
  }

  Future<int?> readIntSecureData(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) {
      return null;
    }
    return int.tryParse(value);
  }

  Future<void> writeDoubleSecureData(String key, double value) async {
    await _storage.write(key: key, value: value.toString());
  }

  Future<double?> readDoubleSecureData(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) {
      return null;
    }
    return double.tryParse(value);
  }

  Future<void> writeListSecureData(String key, List<dynamic> value) async {
    try {
      final listEncoded = jsonEncode(value);
      await _storage.write(key: key, value: listEncoded);
    } catch (_) {
      // JSON encode veya yazma hatasında sessizce devam edilir.
    }
  }

  Future<List<dynamic>> readListSecureData(String key) async {
    final listEncoded = await _storage.read(key: key);
    if (listEncoded == null || listEncoded.isEmpty) {
      return [];
    }

    try {
      return jsonDecode(listEncoded) as List<dynamic>;
    } catch (_) {
      return [];
    }
  }

  Future<void> deleteAllSearchQueries({String key = 'search_queries'}) async {
    await _storage.delete(key: key);
  }

  Future<bool> writeMapSecureData(String key, Map<String, dynamic> value) async {
    try {
      final mapEncoded = jsonEncode(value);
      await _storage.write(key: key, value: mapEncoded);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> readMapSecureData(String key) async {
    final mapEncoded = await _storage.read(key: key);
    if (mapEncoded == null || mapEncoded.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      return Map<String, dynamic>.from(jsonDecode(mapEncoded) as Map);
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}
