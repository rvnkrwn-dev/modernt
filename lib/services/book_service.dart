import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moderent/core/constant.dart';
import 'dart:io';
import 'package:path/path.dart';

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

  Future<Map<String, dynamic>?> uploadPaymentProof({
    required int bookingId,
    required File image, // The payment proof image file
  }) async {
    try {
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        return {'success': false, 'message': 'Access token not found'};
      }

      _dio.options.headers['Authorization'] = 'Bearer $accessToken';

      // Prepare the file as form data
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          image.path,
          filename: basename(image.path),
        ),
      });

      final response = await _dio.put(
        '/api/book/user/payment/$bookingId', // Using the booking ID in the URL
        data: formData,
      );

      final data = response.data;

      if (data['statusCode'] == 200) {
        return {
          'success': true,
          'message': 'Payment proof uploaded successfully.',
          'data': {
            'id': data['data']['id'],
            'user_id': data['data']['user_id'],
            'vehicle_id': data['data']['vehicle_id'],
            'rental_period': data['data']['rental_period'],
            'start_date': data['data']['start_date'],
            'end_date': data['data']['end_date'],
            'delivery_location': data['data']['delivery_location'],
            'rental_status': data['data']['rental_status'],
            'total_price': data['data']['total_price'],
            'secure_url_image': data['data']['secure_url_image'],
            'public_url_image': data['data']['public_url_image'],
            'payment_proof': data['data']['payment_proof'],
            'bank_transfer': data['data']['bank_transfer'],
            'notes': data['data']['notes'],
            'created_at': data['data']['created_at'],
            'updated_at': data['data']['updated_at'],
          },
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to upload payment proof: ${data['message']}',
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Failed to upload payment proof: ${e.response?.data}',
        };
      } else {
        return {'success': false, 'message': 'Network error: ${e.message}'};
      }
    }
  }

  Future<Map<String, dynamic>?> getBookingHistory() async {
  try {
    // Retrieve the access token from secure storage
    final accessToken = await _storage.read(key: 'access_token');

    if (accessToken == null) {
      return {'success': false, 'message': 'Access token not found'};
    }

    // Add the token to the request headers
    _dio.options.headers['Authorization'] = 'Bearer $accessToken';

    // Send the GET request to fetch the booking history
    final response = await _dio.get('/api/book/user/history');

    final data = response.data;

    // Check if the request was successful
    if (data['statusCode'] == 200) {
      return {
        'success': true,
        'message': 'Booking history retrieved successfully.',
        'data': data['data'], // Contains the booking history data
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to retrieve booking history: ${data['message']}',
      };
    }
  } on DioException catch (e) {
    if (e.response != null) {
      return {
        'success': false,
        'message': 'Failed to retrieve booking history: ${e.response?.data}',
      };
    } else {
      return {'success': false, 'message': 'Network error: ${e.message}'};
    }
  }
}

}
