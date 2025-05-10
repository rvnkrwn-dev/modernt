import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moderent/core/constant.dart';

class BankTransferService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> getBankTransfers() async {
    try {
      final accessToken = await _storage.read(key: 'access_token');

      if (accessToken == null) {
        return {'success': false, 'message': 'Access token not found'};
      }

      _dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final response = await _dio.get('/api/bank-transfer');

      final data = response.data;

      if (data['statusCode'] == 200) {
        return {
          'success': true,
          'message': data['message'],
          'bankTransfers': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch bank transfers: ${data['message']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Failed to fetch bank transfers: ${e.response?.data}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }
}
