import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moderent/core/constant.dart';

class BookService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> createBooking({
    required int vehicleId,
    required int deliveryLocationId,
    required int bankTransferId,
    required String startDate, // Format ISO String "2025-05-01T09:00:00.000Z"
    required String endDate,
    required String notes,
  }) async {
    try {
      final accessToken = await _storage.read(key: 'access_token');

      if (accessToken == null) {
        return {'success': false, 'message': 'Access token not found'};
      }

      _dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final response = await _dio.post(
        '/api/book/create',
        data: {
          "vehicle_id": vehicleId,
          "delivery_location": deliveryLocationId,
          "bank_transfer": bankTransferId,
          "start_date": startDate,
          "end_date": endDate,
          "notes": notes,
        },
      );

      final data = response.data;

      print(data);

      if (data['statusCode'] == 201 || data['statusCode'] == 200) {
        return {
          'success': true,
          'message': data['message'],
          'booking': data['data'], // Kalau mau pakai data booking-nya
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to create booking: ${data['message']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Failed to create booking: ${e.response?.data}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }
}
