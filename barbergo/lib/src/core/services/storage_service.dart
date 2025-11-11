import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de armazenamento local

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // ============================================
  // STRING
  // ============================================

  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  String? getString(String key, {String? defaultValue}) {
    return _prefs!.getString(key) ?? defaultValue;
  }

  // ============================================
  // INT
  // ============================================

  Future<bool> setInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }

  int? getInt(String key, {int? defaultValue}) {
    return _prefs!.getInt(key) ?? defaultValue;
  }

  // ============================================
  // DOUBLE
  // ============================================

  Future<bool> setDouble(String key, double value) async {
    return await _prefs!.setDouble(key, value);
  }

  double? getDouble(String key, {double? defaultValue}) {
    return _prefs!.getDouble(key) ?? defaultValue;
  }

  // ============================================
  // BOOL
  // ============================================

  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  bool? getBool(String key, {bool? defaultValue}) {
    return _prefs!.getBool(key) ?? defaultValue;
  }

  // ============================================
  // STRING LIST
  // ============================================

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs!.setStringList(key, value);
  }

  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    return _prefs!.getStringList(key) ?? defaultValue;
  }

  // ============================================
  // JSON
  // ============================================

  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // OPERATIONS
  // ============================================

  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs!.clear();
  }

  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }

  Set<String> getKeys() {
    return _prefs!.getKeys();
  }
}
