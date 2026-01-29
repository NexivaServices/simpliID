import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/capture/models/models.dart';
import '../cache/cache_service.dart';
import 'capture_api_client.dart';
import 'dio_capture_api_client.dart';
import 'dio_provider.dart';
import 'mock_capture_api_client.dart';
import 'network_manager.dart';

/// Configuration for API
class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    required this.useMockApi,
  });

  final String baseUrl;
  final bool useMockApi;
}

/// Provider for API configuration
final apiConfigProvider = Provider<ApiConfig>((ref) {
  // TODO: Read from environment variables or app config
  return const ApiConfig(
    baseUrl: 'https://api.example.com/v1',
    useMockApi: true, // Set to false for production
  );
});

/// Provider for CaptureApiClient implementation
final captureApiClientProvider = Provider<CaptureApiClient>((ref) {
  final config = ref.watch(apiConfigProvider);

  if (config.useMockApi) {
    return MockCaptureApiClient();
  } else {
    final apiClient = ref.watch(apiClientProvider);
    final networkManager = ref.watch(networkManagerProvider);
    
    return DioCaptureApiClient(
      apiClient: apiClient,
      networkManager: networkManager,
      baseUrl: config.baseUrl,
    );
  }
});

/// Cached version of fetch students with local storage
final cachedFetchStudentsProvider = FutureProvider.family<FetchStudentsResponse, FetchStudentsRequest>(
  (ref, request) async {
    final cacheService = ref.watch(cacheServiceProvider);
    final apiClient = ref.watch(captureApiClientProvider);
    final isConnected = await ref.watch(isConnectedProvider.future);

    final cacheKey = 'students_${request.orderId}_${request.page ?? 1}';

    // Try to get from cache first
    final cached = cacheService.get<Map<String, dynamic>>(cacheKey);
    if (cached != null && !isConnected) {
      // Return cached data if offline
      return FetchStudentsResponse.fromJson(cached);
    }

    try {
      // Fetch from API
      final response = await apiClient.fetchStudents(request);

      // Cache the response for 30 minutes
      await cacheService.save(
        cacheKey,
        response.toJson(),
        expiration: const Duration(minutes: 30),
      );

      return response;
    } catch (e) {
      // If fetch fails and we have cache, return it
      if (cached != null) {
        return FetchStudentsResponse.fromJson(cached);
      }
      rethrow;
    }
  },
);

/// Provider for login with cache
final loginProvider = FutureProvider.family<LoginResponse, LoginRequest>(
  (ref, request) async {
    final apiClient = ref.watch(captureApiClientProvider);
    return apiClient.login(request);
  },
);

/// Provider for sync batch
final syncBatchProvider = FutureProvider.family<SyncBatchResponse, SyncBatchRequest>(
  (ref, request) async {
    final apiClient = ref.watch(captureApiClientProvider);
    return apiClient.syncBatch(request);
  },
);
