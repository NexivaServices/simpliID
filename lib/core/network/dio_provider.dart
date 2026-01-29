import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../connectivity/connectivity_providers.dart';
import 'api_client.dart';
import 'dio_interceptors.dart';

/// Provider for base Dio instance with all interceptors
final dioProvider = Provider<Dio>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (status) {
        // Accept all status codes to handle them manually
        return status != null && status < 500;
      },
    ),
  );

  // Add interceptors in order
  dio.interceptors.addAll([
    ConnectivityInterceptor(connectivity: connectivity),
    LoggingInterceptor(),
    RetryInterceptor(
      maxRetries: 3,
      retryDelay: const Duration(seconds: 1),
    ),
    // Auth interceptor will be added when token provider is available
  ]);

  return dio;
});

/// Provider for API client
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio: dio);
});

