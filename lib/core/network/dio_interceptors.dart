import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Interceptor for logging requests and responses in debug mode
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ REQUEST: ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      debugPrint('└─────────────────────────────────────────────────');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│ Data: ${response.data}');
      debugPrint('└─────────────────────────────────────────────────');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ ERROR: ${err.type} ${err.requestOptions.uri}');
      debugPrint('│ Message: ${err.message}');
      debugPrint('│ Response: ${err.response?.data}');
      debugPrint('└─────────────────────────────────────────────────');
    }
    super.onError(err, handler);
  }
}

/// Interceptor for adding authentication token to requests
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.getToken});

  final Future<String?> Function() getToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

/// Interceptor for checking network connectivity before making requests
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor({required this.connectivity});

  final Connectivity connectivity;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connectivityResult = await connectivity.checkConnectivity();
    
    // Check if there's no internet connection
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const NoInternetException('No internet connection available'),
        ),
      );
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert connection errors to NoInternetException
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.error is SocketException)) {
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          type: DioExceptionType.connectionError,
          error: const NoInternetException('Connection failed. Please check your internet.'),
        ),
      );
    }
    super.onError(err, handler);
  }
}

/// Interceptor for retry logic with exponential backoff
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  final int maxRetries;
  final Duration retryDelay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      return super.onError(err, handler);
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (retryCount >= maxRetries) {
      return super.onError(err, handler);
    }

    // Calculate exponential backoff delay
    final delay = retryDelay * (1 << retryCount); // 1s, 2s, 4s, etc.
    
    if (kDebugMode) {
      debugPrint('Retrying request (${retryCount + 1}/$maxRetries) after ${delay.inSeconds}s...');
    }

    await Future<void>.delayed(delay);

    // Clone the request options and increment retry count
    final options = err.requestOptions;
    options.extra['retryCount'] = retryCount + 1;

    try {
      final response = await Dio().fetch(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return super.onError(e, handler);
    }
  }

  bool _shouldRetry(DioException err) {
    // Don't retry on client errors (4xx) except 408 (timeout)
    if (err.response?.statusCode != null) {
      final statusCode = err.response!.statusCode!;
      if (statusCode >= 400 && statusCode < 500 && statusCode != 408) {
        return false;
      }
    }

    // Retry on network errors and server errors (5xx)
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

/// Custom exception for no internet connection
class NoInternetException implements Exception {
  const NoInternetException(this.message);

  final String message;

  @override
  String toString() => message;
}
