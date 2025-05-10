import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moderent/core/constant.dart';

class AddressService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> createAddress({
    required String fullName,
    required String address,
    required String phone,
    required String fullAddress,
    required String latitude,
    required String longitude,
  }) async {
    try {
      // Ambil access token dari storage
      final accessToken = await _storage.read(key: 'access_token');

      if (accessToken == null) {
        return {'success': false, 'message': 'Access token not found'};
      }

      // Set Authorization header
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final response = await _dio.post(
        '/api/address',
        data: {
          "full_name": fullName,
          "address": address,
          "phone": phone,
          "full_address": fullAddress,
          "latitude": latitude,
          "longitude": longitude,
        },
      );

      final data = response.data;

      if (data['statusCode'] == 201) {
        // Biasanya create pakai 201
        return {
          'success': true,
          'message': data['message'],
          'address': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to create address: ${data['message']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Failed to create address: ${e.response?.data}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }

  Future<Map<String, dynamic>?> getAddresses() async {
    try {
      // Ambil access token dari storage
      final accessToken = await _storage.read(key: 'access_token');

      if (accessToken == null) {
        return {'success': false, 'message': 'Access token not found'};
      }

      // Set Authorization header
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final response = await _dio.get('/api/address');

      final data = response.data;

      if (data['statusCode'] == 200) {
        return {
          'success': true,
          'message': data['message'],
          'addresses': data['data'], // List of addresses
          'pagination': data['pagination'], // Info pagination kalau perlu
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch addresses: ${data['message']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Failed to fetch addresses: ${e.response?.data}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }

  Future<Map<String, dynamic>> deleteAddress(int id) async {
    try {
      // Get access token from storage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        return {'success': false, 'message': 'Access token not found'};
      }

      // Set Authorization header
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';

      // Make API call
      final response = await _dio.delete('/api/address/$id');
      final data = response.data;

      // Process response
      if (data['statusCode'] == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Address deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message':
              'Failed to delete address: ${data['message'] ?? 'Unknown error'}',
        };
      }
    } on DioException catch (e) {
      // Handle Dio-specific exceptions
      String errorMessage = 'Network error';

      if (e.response != null) {
        final responseData = e.response?.data;
        errorMessage =
            responseData is Map
                ? responseData['message'] ?? 'Server error'
                : 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Receive timeout';
      } else {
        errorMessage = e.message ?? 'Unknown error';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      // Handle general exceptions
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }
}
