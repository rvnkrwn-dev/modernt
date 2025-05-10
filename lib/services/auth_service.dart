import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moderent/core/constant.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  final _storage = FlutterSecureStorage();

  // Register
  Future<Map<String, dynamic>?> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {'username': username, 'email': email, 'password': password},
      );

      final data = response.data;

      if (data['statusCode'] == 201) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': 'Register failed: ${data['message']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Register failed: ${e.response?.data}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }

  // Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data;

      if (data['statusCode'] == 200) {
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final user = data['user'];

        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);
        await _storage.write(key: 'user', value: jsonEncode(user));

        return {'success': true, 'message': data['message'], 'user': user};
      } else {
        return {
          'success': false,
          'message': 'Login failed: ${data['message']['error']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Login failed: ${e.response?.data['error']}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }

  // Logout
  Future<Map<String, dynamic>?> logout() async {
    try {
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      await _storage.delete(key: 'user');

      return {'success': true, 'message': 'Logout successful'};
    } catch (e) {
      return {'success': false, 'message': 'Logout failed: $e'};
    }
  }

  // Refresh Token
  Future<Map<String, dynamic>?> refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');

      if (refreshToken == null) {
        return {'success': false, 'message': 'No refresh token found'};
      }

      final response = await _dio.get(
        '/api/auth/refresh',
        options: Options(
          headers: {
            'Cookie':
                'refresh_token=$refreshToken', // Kirim refresh token via cookie
          },
        ),
      );

      final data = response.data;

      if (data['statusCode'] == 200) {
        final newAccessToken = data['accessToken'];
        await _storage.write(key: 'access_token', value: newAccessToken);

        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': 'Refresh failed: ${data['message']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Refresh failed: ${e.response?.data}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }

  // Get User
  Future<Map<String, dynamic>?> getUser() async {
    try {
      final accessToken = await _storage.read(key: 'access_token');

      if (accessToken == null) {
        return {'success': false, 'message': 'No access token found'};
      }

      final response = await _dio.get(
        '/api/auth/user',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final data = response.data;

      if (data['statusCode'] == 200) {
        final userData = data['data'];

        await _storage.write(key: 'user', value: jsonEncode(userData));

        return {'success': true, 'user': userData};
      } else {
        return {
          'success': false,
          'message': 'Get user failed: ${data['message']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Get user failed: ${e.response?.data}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }

  // Initialize Auth - check and refresh token
  Future<Map<String, dynamic>?> initAuth() async {
    try {
      // Selalu refresh token dulu
      final refreshResponse = await refreshToken();

      if (refreshResponse != null && refreshResponse['success'] == true) {
        // Refresh berhasil, ambil access token baru
        return await getUser();
      } else {
        // Refresh gagal, logout
        await logout();
        return {
          'success': false,
          'message': 'Session expired, please login again.',
        };
      }
    } catch (e) {
      await logout();
      return {
        'success': false,
        'message': 'An error occurred, please login again.',
      };
    }
  }
}
