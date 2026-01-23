import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/models/index.dart' as models;

class SupabaseService {
  // Supabase credentials
  static const String supabaseUrl = 'https://fttnuccbqqesklwaceyj.supabase.co';
  static const String anonKey = 'sb_publishable_boq5LvhP882ypmONUaFx9Q_5aapoxFo';
  
  // Flag untuk tracking apakah Supabase berhasil connect
  static bool _isConnected = false;
  static bool get isConnected => _isConnected;

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: anonKey,
      );
      _isConnected = true;
      // ignore: avoid_print
      print('✅ Supabase connected successfully');
    } catch (e) {
      _isConnected = false;
      // ignore: avoid_print
      print('⚠️ Supabase connection failed: $e');
      // Still proceed - will use fallback auth
      rethrow;
    }
  }

  static SupabaseClient get client => Supabase.instance.client;

  static Future<bool> signUp(String email, String password, {String? fullName}) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          if (fullName != null) 'full_name': fullName,
        },
      );

      if (response.user != null) {
        // ignore: avoid_print
        print('✅ User berhasil didaftar di Supabase: $email');
      }
      return response.user != null;
    } on AuthException catch (e) {
      // ignore: avoid_print
      print('❌ Auth Error (signUp): ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error (signUp): $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', response.user!.id);
        await prefs.setString('user_email', response.user!.email ?? '');
        if (response.user!.userMetadata?['full_name'] != null) {
          await prefs.setString(
            'user_name',
            response.user!.userMetadata!['full_name'],
          );
        }

        return {
          'success': true,
          'user': response.user,
          'message': 'Login berhasil',
        };
      }

      return {
        'success': false,
        'message': 'Login gagal',
      };
    } on AuthException catch (e) {
      return {
        'success': false,
        'message': e.message.contains('Failed to fetch') 
          ? 'Tidak dapat terhubung ke server. Menggunakan mode demo...'
          : e.message,
      };
    } catch (e) {
      final errorMsg = e.toString();
      return {
        'success': false,
        'message': errorMsg.contains('Failed to fetch') || errorMsg.contains('ERR_NAME_NOT_RESOLVED')
          ? 'Tidak dapat terhubung ke Supabase. Menggunakan mode demo...'
          : 'Terjadi kesalahan: $errorMsg',
      };
    }
  }

  static Future<bool> signOut() async {
    try {
      await client.auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    final session = client.auth.currentSession;
    return session != null;
  }

  static User? getCurrentUser() {
    return client.auth.currentUser;
  }

  static String? getUserId() {
    return client.auth.currentUser?.id;
  }

  static String? getUserEmail() {
    return client.auth.currentUser?.email;
  }

  static String? getUserName() {
    return client.auth.currentUser?.userMetadata?['full_name'] as String?;
  }

  // Refresh session
  static Future<bool> refreshSession() async {
    try {
      final session = client.auth.currentSession;
      if (session != null) {
        await client.auth.refreshSession();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Check and restore session
  static Future<bool> restoreSession() async {
    try {
      final session = client.auth.currentSession;
      return session != null;
    } catch (e) {
      return false;
    }
  }

  // Database operations
  static Future<List<Map<String, dynamic>>> query(
    String table, {
    List<String>? select,
    Map<String, dynamic>? filters,
  }) async {
    try {
      var query = client.from(table).select(select?.join(',') ?? '*');

      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      return await query;
    } catch (e) {
      // Fallback: try load local seed data from assets when network/Supabase unavailable
      try {
        final raw = await rootBundle.loadString('assets/seed_data.json');
        final Map<String, dynamic> seed = jsonDecode(raw) as Map<String, dynamic>;
        if (seed.containsKey(table)) {
          final data = seed[table] as List<dynamic>;
          // Convert to List<Map<String,dynamic>>
          return data.map((d) => Map<String, dynamic>.from(d as Map)).toList();
        }
      } catch (_) {
        // ignore
      }
      return [];
    }
  }

  // Typed getters that map raw rows to model objects, using fallback data when needed
  static Future<List<models.Restaurant>> getRestaurants() async {
    final rows = await query('restaurants');
    return rows.map((r) => models.Restaurant.fromJson(r)).toList();
  }

  static Future<List<models.Food>> getFoods({int? restaurantId}) async {
    final filters = restaurantId != null ? {'restaurant_id': restaurantId} : null;
    final rows = await query('foods', filters: filters);
    return rows.map((r) => models.Food.fromJson(r)).toList();
  }

  static Future<List<models.PromoCode>> getPromos() async {
    final rows = await query('promos');
    return rows.map((r) => models.PromoCode.fromJson(r)).toList();
  }

  static Future<List<models.Comment>> getComments({String? foodId}) async {
    final filters = foodId != null ? {'food_id': foodId} : null;
    final rows = await query('comments', filters: filters);
    return rows.map((r) => models.Comment.fromJson(r)).toList();
  }

  static Future<Map<String, dynamic>?> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await client.from(table).insert(data).select();
      return response.isNotEmpty ? response[0] : null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> update(
    String table,
    Map<String, dynamic> data,
    String id,
  ) async {
    try {
      await client.from(table).update(data).eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> delete(String table, String id) async {
    try {
      await client.from(table).delete().eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
