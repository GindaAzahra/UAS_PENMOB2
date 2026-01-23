import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_service.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userEmailKey = 'userEmail';
  static const String _userRoleKey = 'userRole';
  static const String _userNameKey = 'userName';
  static const String _userIdKey = 'userId';
  static const String _pendingRegsKey = 'pending_registrations';
  
  // Stored password cache untuk offline access
  static final Map<String, String> _passwordCache = {};

  // Helper: add pending registration to local storage
  static Future<void> _addPendingRegistration(String email, String password, String? fullName) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_pendingRegsKey);
    final List pending = raw == null ? [] : jsonDecode(raw) as List;
    pending.add({
      'email': email,
      'password': password,
      'full_name': fullName,
      'created_at': DateTime.now().toIso8601String(),
    });
    await prefs.setString(_pendingRegsKey, jsonEncode(pending));
  }
  
  // Validasi format email
  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Validasi input
      if (email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Email dan password tidak boleh kosong',
        };
      }

      if (!_isValidEmail(email)) {
        return {
          'success': false,
          'message': 'Format email tidak valid',
        };
      }

      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password minimal 6 karakter',
        };
      }

      // Try login dengan Supabase
      final result = await SupabaseService.signIn(email, password);
      
      if (result['success']) {
        // Login berhasil di Supabase
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_userEmailKey, email);
        await prefs.setString(_userRoleKey, 'user');
        
        // Ambil user name dari metadata atau dari email
        String userName = email.split('@')[0];
        if (result['user'] != null && result['user'].userMetadata?['full_name'] != null) {
          userName = result['user'].userMetadata!['full_name'];
        }
        
        await prefs.setString(_userNameKey, userName);
        
        // Simpan user ID jika tersedia
        if (result['user'] != null && result['user'].id != null) {
          await prefs.setString(_userIdKey, result['user'].id);
        }
        
        // Cache password untuk offline access
        _passwordCache[email] = password;
        
        return {
          'success': true,
          'message': 'Login berhasil',
          'user': result['user'],
        };
      } else {
        // Login gagal
        final errorMsg = result['message'] ?? 'Email atau password salah';
        
        return {
          'success': false,
          'message': errorMsg,
        };
      }
    } catch (e) {
      // Handle network atau exception lainnya
      final errorMsg = e.toString();
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${_sanitizeErrorMessage(errorMsg)}',
      };
    }
  }
  
  // Helper untuk clean up error message
  static String _sanitizeErrorMessage(String error) {
    if (error.contains('Failed to fetch') || error.contains('ERR_NAME_NOT_RESOLVED')) {
      return 'Tidak dapat terhubung ke server';
    }
    if (error.contains('Invalid login credentials')) {
      return 'Email atau password salah';
    }
    if (error.contains('User not found')) {
      return 'Email tidak terdaftar';
    }
    if (error.contains('Email not confirmed')) {
      return 'Email belum dikonfirmasi';
    }
    return error.length > 100 ? error.substring(0, 100) : error;
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String confirmPassword, {
    String? fullName,
  }) async {
    try {
      // Validasi input
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        return {
          'success': false,
          'message': 'Semua field harus diisi',
        };
      }

      if (!_isValidEmail(email)) {
        return {
          'success': false,
          'message': 'Format email tidak valid',
        };
      }

      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password minimal 6 karakter',
        };
      }

      if (password != confirmPassword) {
        return {
          'success': false,
          'message': 'Password tidak cocok',
        };
      }

      // Register di Supabase
      final success = await SupabaseService.signUp(
        email,
        password,
        fullName: fullName,
      );

      if (success) {
        // Registrasi berhasil
        _passwordCache[email] = password;
        
        // Simpan ke preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userEmailKey, email);
        if (fullName != null && fullName.isNotEmpty) {
          await prefs.setString(_userNameKey, fullName);
        }

        return {
          'success': true,
          'message': 'Registrasi berhasil. Silakan cek email untuk verifikasi.',
        };
      } else {
        // Registrasi gagal - simpan untuk retry nanti
        await _addPendingRegistration(email, password, fullName);
        _passwordCache[email] = password;
        
        return {
          'success': true,
          'message': 'Registrasi tersimpan. Akan dicoba sinkronisasi ketika koneksi tersedia.',
        };
      }
    } catch (e) {
      // Exception - simpan untuk retry
      await _addPendingRegistration(email, password, fullName);
      _passwordCache[email] = password;
      
      return {
        'success': true,
        'message': 'Registrasi tersimpan. Akan dicoba sinkronisasi ketika koneksi tersedia.',
      };
    }
  }

  /// Attempt to sync pending registrations from local storage to Supabase.
  /// Returns a map with counts: { synced: n, failed: m }
  Future<Map<String, int>> syncPendingRegistrations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_pendingRegsKey);
    if (raw == null) return {'synced': 0, 'failed': 0};

    final List pending = jsonDecode(raw) as List;
    int synced = 0;
    int failed = 0;
    final remaining = <dynamic>[];

    for (final item in pending) {
      try {
        final email = item['email'] as String;
        final password = item['password'] as String;
        final fullName = item['full_name'] as String?;
        final ok = await SupabaseService.signUp(email, password, fullName: fullName);
        if (ok) {
          synced++;
        } else {
          // keep for later retry
          remaining.add(item);
          failed++;
        }
      } catch (_) {
        remaining.add(item);
        failed++;
      }
    }

    if (remaining.isEmpty) {
      await prefs.remove(_pendingRegsKey);
    } else {
      await prefs.setString(_pendingRegsKey, jsonEncode(remaining));
    }

    return {'synced': synced, 'failed': failed};
  }

  String? get userRole => null;

  Future<bool> isLoggedIn() async {
    return await SupabaseService.isLoggedIn();
  }

  Future<String?> getUserEmail() async {
    return SupabaseService.getUserEmail();
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<String?> getUserId() async {
    return SupabaseService.getUserId();
  }

  Future<void> logout() async {
    await SupabaseService.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userNameKey);
  }
}
