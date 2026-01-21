import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userEmailKey = 'userEmail';
  static const String _userRoleKey = 'userRole';
  static const String _userNameKey = 'userName';

  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Validasi login
    if (email == 'user@gmail.com' && password == 'password123') {
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_userRoleKey, 'user');
      await prefs.setString(_userNameKey, email.split('@')[0]);
      return true;
    }
    return false;
  }

  String? get userRole => null;

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userNameKey);
  }
}
