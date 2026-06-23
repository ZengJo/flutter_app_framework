import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 本地缓存工具：统一缓存 SharedPreferences 实例，避免每次读写都重复初始化。
class PreferencesService {
  PreferencesService._();

  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  /// 兼容旧代码
  static Future<String?> get(String key) => getString(key);

  static Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    return prefs.setString(key, value);
  }

  /// 兼容旧代码
  static Future<bool> set(String key, String value) => setString(key, value);

  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    final prefs = await _instance;
    return prefs.getInt(key) ?? defaultValue;
  }

  static Future<bool> setInt(String key, int value) async {
    final prefs = await _instance;
    return prefs.setInt(key, value);
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _instance;
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<bool> setBool(String key, bool value) async {
    final prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static Future<bool> setJson(String key, Object? value) async {
    final prefs = await _instance;
    return prefs.setString(key, jsonEncode(value));
  }

  /// 兼容旧代码
  static Future<bool> setJSON(String key, Object? value) => setJson(key, value);

  static Future<T?> getJson<T>(String key) async {
    final prefs = await _instance;
    final source = prefs.getString(key);
    if (source == null || source.isEmpty) return null;
    try {
      final decoded = jsonDecode(source);
      return decoded is T ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  /// 兼容旧代码
  static Future<dynamic> getJSON(String key) => getJson<dynamic>(key);


  static Future<List<String>> getStringList(String key) async {
    final prefs = await _instance;
    return prefs.getStringList(key) ?? const <String>[];
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _instance;
    return prefs.setStringList(key, value);
  }

  static Future<bool> remove(String key) async {
    final prefs = await _instance;
    return prefs.remove(key);
  }

  static Future<bool> containsKey(String key) async {
    final prefs = await _instance;
    return prefs.containsKey(key);
  }
}
