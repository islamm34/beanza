import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorage {
  Future<void> saveToken(String key, String token);
  Future<String?> getToken(String key);
  Future<void> deleteToken(String key);
  Future<void> deleteAllTokens();
}

class FlutterSecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage _storage;

  FlutterSecureStorageImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveToken(String key, String token) async {
    await _storage.write(key: key, value: token);
  }

  @override
  Future<String?> getToken(String key) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAllTokens() async {
    await _storage.deleteAll();
  }
}
