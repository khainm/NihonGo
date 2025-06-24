import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveAuthData({
    required String token,
    required String email,
    String? name,
  }) async {
    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_userEmailKey, email);
    if (name != null) {
      await _prefs.setString(_userNameKey, name);
    }
  }

  static Future<void> clearAuthData() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userNameKey);
  }

  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  static String? getUserEmail() {
    return _prefs.getString(_userEmailKey);
  }

  static String? getUserName() {
    return _prefs.getString(_userNameKey);
  }

  static bool isAuthenticated() {
    return getToken() != null;
  }
} 