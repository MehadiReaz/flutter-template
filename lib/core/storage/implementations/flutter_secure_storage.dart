import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Flutter Secure Storage implementation
class FlutterSecureStorageImpl {
  FlutterSecureStorageImpl(this._storage);

  final FlutterSecureStorage _storage;

  /// Write secure data
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Read secure data
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  /// Read all secure data
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  /// Delete secure data
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Delete all secure data
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Check if key exists
  Future<bool> containsKey({required String key}) async {
    return await _storage.containsKey(key: key);
  }

  /// Get all keys
  Future<Set<String>> getKeys() async {
    final data = await _storage.readAll();
    return data.keys.toSet();
  }
}
