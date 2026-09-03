import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Gizlenmesi gerekmeyen verileri saklamak için kullanılan sınıf
class SharedPref {
  SharedPref._();
  static final instance = SharedPref._();

  Future<SharedPreferences> get _preferences async => SharedPreferences.getInstance();

  Future<void> writeData(String key, String value) async {
    final preferences = await _preferences;
    await preferences.setString(key, value);
  }

  Future<String?> readData(String key) async {
    final preferences = await _preferences;
    return preferences.getString(key);
  }

  Future<void> deleteData({String? key}) async {
    final preferences = await _preferences;
    if (key != null) {
      await preferences.remove(key);
      return;
    }
    await preferences.clear();
  }

  Future<void> writeBool(String key, bool value) async {
    final preferences = await _preferences;
    await preferences.setBool(key, value);
  }

  Future<bool?> readBool(String key) async {
    final preferences = await _preferences;
    return preferences.getBool(key);
  }

  Future<void> writeInt(String key, int value) async {
    final preferences = await _preferences;
    await preferences.setInt(key, value);
  }

  Future<int?> readInt(String key) async {
    final preferences = await _preferences;
    return preferences.getInt(key);
  }

  Future<void> writeDouble(String key, double value) async {
    final preferences = await _preferences;
    await preferences.setDouble(key, value);
  }

  Future<double?> readDouble(String key) async {
    final preferences = await _preferences;
    return preferences.getDouble(key);
  }

  Future<void> writeListData(String key, List<dynamic> value) async {
    final preferences = await _preferences;
    await preferences.setString(key, jsonEncode(value));
  }

  Future<List<dynamic>> readListData(String key) async {
    final preferences = await _preferences;
    final encoded = preferences.getString(key);
    if (encoded == null || encoded.isEmpty) {
      return [];
    }

    try {
      return jsonDecode(encoded) as List<dynamic>;
    } catch (_) {
      return [];
    }
  }

  Future<void> writeMapData(String key, Map<String, dynamic> value) async {
    final preferences = await _preferences;
    await preferences.setString(key, jsonEncode(value));
  }

  Future<Map<String, dynamic>> readMapData(String key) async {
    final preferences = await _preferences;
    final encoded = preferences.getString(key);
    if (encoded == null || encoded.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      return Map<String, dynamic>.from(jsonDecode(encoded) as Map);
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}
