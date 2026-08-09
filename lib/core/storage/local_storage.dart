import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<void> save(String key, String value);
  Future<String?> get(String key);
  Future<bool?> getBool(String key);
  Future<int?> getInt(String key);
  Future<List<String>?> getStringList(String key);
  Future<void> saveBool(String key, bool value);
  Future<void> saveInt(String key, int value);
  Future<void> saveStringList(String key, List<String> value);
  Future<void> delete(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

class SharedPreferencesLocalStorage implements LocalStorage {
  final SharedPreferences _prefs;

  SharedPreferencesLocalStorage(this._prefs);

  @override
  Future<void> save(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> get(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  @override
  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return _prefs.getStringList(key);
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<void> saveStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }
}
