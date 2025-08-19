import 'package:dio/dio.dart';
import 'package:flutter_structure/bootstrap/environment_config.dart';

/// API client for handling HTTP requests
/// Built on top of Dio with interceptors and error handling
class ApiClient {
  ApiClient(this._dio) {
    _setupInterceptors();
  }

  final Dio _dio;

  /// Setup interceptors
  void _setupInterceptors() {
    // Request interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add authorization header if available
          // options.headers['Authorization'] = 'Bearer $token';

          // Add common headers
          options.headers.addAll({
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          });

          handler.next(options);
        },
        onResponse: (response, handler) {
          // Handle successful responses
          handler.next(response);
        },
        onError: (error, handler) {
          // Handle errors
          _handleError(error);
          handler.next(error);
        },
      ),
    );

    // Retry interceptor for failed requests
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        maxRetries: 3,
        retryDelay: const Duration(seconds: 1),
      ),
    );

    // Logging interceptor (only in debug mode)
    if (EnvironmentConfig.debugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => print(obj),
        ),
      );
    }
  }

  /// Handle API errors
  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException('Request timeout');
      case DioExceptionType.badResponse:
        throw ServerException(
          'Server error: ${error.response?.statusCode}',
          error.response?.statusCode ?? 0,
        );
      case DioExceptionType.cancel:
        throw CancellationException('Request cancelled');
      case DioExceptionType.connectionError:
        throw ConnectionException('Connection error');
      default:
        throw UnknownException('Unknown error occurred');
    }
  }

  /// GET request
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// POST request
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

/// Retry interceptor
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retryCount'] == null) {
      err.requestOptions.extra['retryCount'] = 0;
    }

    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    if (_shouldRetry(err) && (retryCount as int) < maxRetries) {
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      await Future<void>.delayed(retryDelay);

      try {
        final response = await dio.fetch<dynamic>(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

/// Custom exceptions
/// Base API exception class
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => 'ApiException: $message';
}

/// Timeout exception
class TimeoutException extends ApiException {
  TimeoutException(super.message);
}

/// Server exception
class ServerException extends ApiException {
  ServerException(super.message, this.statusCode);
  final int statusCode;
}

/// Cancellation exception
class CancellationException extends ApiException {
  CancellationException(super.message);
}

/// Connection exception
class ConnectionException extends ApiException {
  ConnectionException(super.message);
}

/// Unknown exception
class UnknownException extends ApiException {
  UnknownException(super.message);
}
