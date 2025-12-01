import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final _authErrorController = StreamController<void>.broadcast();

  factory ApiService() {
    return _instance;
  }

  Stream<void> get authStateChanges => _authErrorController.stream;

  ApiService._internal() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          _authErrorController.add(null);
        }
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;

  static String handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final response = error.response;
          if (response != null) {
            if (response.statusCode == 401) {
              return 'Invalid email or password.';
            }
            if (response.statusCode == 422) {
              // Validation error
              if (response.data is Map && response.data.containsKey('message')) {
                return response.data['message'];
              }
              if (response.data is Map && response.data.containsKey('errors')) {
                final errors = response.data['errors'];
                if (errors is Map && errors.isNotEmpty) {
                  return errors.values.first.first.toString();
                }
              }
            }
            if (response.data is Map && response.data.containsKey('message')) {
              return response.data['message'];
            }
            return 'Server error: ${response.statusCode}';
          }
          return 'Received invalid status code: ${error.response?.statusCode}';
        case DioExceptionType.cancel:
          return 'Request cancelled';
        case DioExceptionType.unknown:
          if (error.error != null && error.error.toString().contains('SocketException')) {
            return 'No internet connection.';
          }
          return 'Unexpected error occurred.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }
    return error.toString();
  }
}
