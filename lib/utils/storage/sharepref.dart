import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _userKey = 'user_info';
  Future<bool> setData(String key, String value) async {
    var storage = await SharedPreferences.getInstance();
    var response = await storage.setString(key, value);
    return response;
  }

  Future<String?> getData(String key) async {
    var storage = await SharedPreferences.getInstance();
    var response = storage.getString(key);
    return response;
  }

  Future<void> saveUser(String userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userJson);
  }

  Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }
}
