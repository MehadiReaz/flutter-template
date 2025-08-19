/// Storage manager that provides unified access to different storage solutions
class StorageManager {
  StorageManager({
    required this.sharedPreferencesStorage,
    required this.secureStorage,
  });

  final SharedPreferencesStorage sharedPreferencesStorage;
  final FlutterSecureStorageImpl secureStorage;

  /// Save data to appropriate storage based on sensitivity
  Future<void> save(String key, dynamic value, {bool secure = false}) async {
    if (secure) {
      await secureStorage.write(key, value?.toString() ?? '');
    } else {
      await sharedPreferencesStorage.write(key, value);
    }
  }

  /// Read data from appropriate storage
  Future<T?> read<T>(String key, {bool secure = false}) async {
    if (secure) {
      final value = await secureStorage.read(key);
      return value as T?;
    } else {
      return await sharedPreferencesStorage.read<T>(key);
    }
  }

  /// Remove data from storage
  Future<void> remove(String key, {bool secure = false}) async {
    if (secure) {
      await secureStorage.delete(key);
    } else {
      await sharedPreferencesStorage.delete(key);
    }
  }

  /// Clear all data from storage
  Future<void> clear({bool secure = false}) async {
    if (secure) {
      await secureStorage.deleteAll();
    } else {
      await sharedPreferencesStorage.clear();
    }
  }

  /// Check if key exists
  Future<bool> containsKey(String key, {bool secure = false}) async {
    if (secure) {
      return await secureStorage.containsKey(key);
    } else {
      return await sharedPreferencesStorage.containsKey(key);
    }
  }
}

// Placeholder classes - these would be implemented in their respective files
class SharedPreferencesStorage {
  SharedPreferencesStorage(dynamic prefs);

  Future<void> write(String key, dynamic value) async {}
  Future<T?> read<T>(String key) async => null;
  Future<void> delete(String key) async {}
  Future<void> clear() async {}
  Future<bool> containsKey(String key) async => false;
}

class FlutterSecureStorageImpl {
  FlutterSecureStorageImpl(dynamic storage);

  Future<void> write(String key, String value) async {}
  Future<String?> read(String key) async => null;
  Future<void> delete(String key) async {}
  Future<void> deleteAll() async {}
  Future<bool> containsKey(String key) async => false;
}
