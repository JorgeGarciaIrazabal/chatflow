import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatflow/src/core/models/user_model.dart';

class AuthRepository {
  static const String _baseUrl = 'http://127.0.0.1:8000';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final SharedPreferences _preferences;

  AuthRepository(this._preferences);

  Future<User> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': email,
        'password': password,
        'grant_type': 'password',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> tokenData = json.decode(response.body);
      final String accessToken = tokenData['access_token'] as String;
      await _secureStorage.write(key: 'access_token', value: accessToken);
      
      // Get user info
      final userResponse = await http.get(
        Uri.parse('$_baseUrl/auth/me'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (userResponse.statusCode == 200) {
        final user = User.fromJson(json.decode(userResponse.body));
        await _preferences.setString('user', json.encode(user.toJson()));
        return user;
      } else {
        throw Exception('Failed to get user information');
      }
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  Future<User> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'full_name': fullName,
      }),
    );

    if (response.statusCode == 201) {
      final user = User.fromJson(json.decode(response.body));
      
      // Auto-login after registration
      return login(email: email, password: password);
    } else {
      throw Exception('Registration failed: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _preferences.remove('user');
  }

  Future<User?> getCurrentUser() async {
    final userJson = _preferences.getString('user');
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    if (kDebugMode) {
      final fakeUser = User(
        id: -1,
        email: 'debug@test.com',
        fullName: 'Debug User',
        isActive: true,
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _preferences.setString('user', json.encode(fakeUser.toJson()));
      return fakeUser;
    }
    return null;
  }

  Future<String?> getToken() async {
    final token = await _secureStorage.read(key: 'access_token');
    if (token != null) {
      return token;
    }
    if (kDebugMode) {
      const fakeToken = 'fake_token_for_debug';
      await _secureStorage.write(key: 'access_token', value: fakeToken);
      return fakeToken;
    }
    return null;
  }
}
