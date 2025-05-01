import 'package:dio/dio.dart';
import 'package:moderent/core/constant.dart';

class VehicleService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Map<String, dynamic>?> getVehicles({
    int itemsPerPage = 10,
    int skip = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/api/vehicles',
        queryParameters: {
          'itemsPerPage': itemsPerPage,
          'skip': skip,
        },
      );

      final data = response.data;

      if (data['statusCode'] == 200) {
        return {
          'success': true,
          'message': data['message'],
          'vehicles': data['data'],
          'pagination': data['pagination'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to retrieve vehicles: ${data['message']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Failed to retrieve vehicles: ${e.response?.data}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }

  Future<Map<String, dynamic>?> getVehicleById(int id) async {
    try {
      final response = await _dio.get('/api/vehicles/$id');

      final data = response.data;

      if (data['statusCode'] == 200) {
        return {
          'success': true,
          'message': data['message'],
          'vehicle': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to retrieve vehicle: ${data['message']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Failed to retrieve vehicle: ${e.response?.data}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }
}
