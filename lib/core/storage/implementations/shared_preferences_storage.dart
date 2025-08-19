import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences storage implementation
class SharedPreferencesStorage {
  SharedPreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  /// Save string value
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Get string value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Save int value
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// Get int value
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Save bool value
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// Get bool value
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Save double value
  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// Get double value
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Save string list value
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  /// Get string list value
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Remove value
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// Clear all values
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Get all keys
  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}
