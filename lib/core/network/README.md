# Network & Caching System Documentation

## Overview

A comprehensive Dio-based networking solution with automatic retry, network connectivity checking, request cancellation, and local caching using Riverpod and Hive.

## Features

### ✅ **Network Management**
- ✅ Automatic network connectivity checking before requests
- ✅ Request cancellation when connection is lost
- ✅ Real-time network status monitoring
- ✅ Manual request cancellation by tag
- ✅ Cancel all ongoing requests

### ✅ **HTTP Methods**
- ✅ GET requests
- ✅ POST requests (JSON)
- ✅ POST requests (FormData/Multipart)
- ✅ PUT requests
- ✅ PATCH requests
- ✅ DELETE requests
- ✅ File downloads with progress tracking

### ✅ **Interceptors**
- ✅ **Logging Interceptor**: Debug logging for all requests/responses
- ✅ **Auth Interceptor**: Automatic token injection
- ✅ **Connectivity Interceptor**: Pre-flight network checks
- ✅ **Retry Interceptor**: Automatic retry with exponential backoff (up to 3 retries)

### ✅ **Caching System**
- ✅ Local cache storage using Hive
- ✅ Automatic cache expiration
- ✅ Cache size management
- ✅ Offline-first capability
- ✅ Clear expired cache entries
- ✅ Manual cache control

### ✅ **Error Handling**
- ✅ Custom `NoInternetException` for connection issues
- ✅ User-friendly error messages
- ✅ Automatic error recovery with retry
- ✅ Graceful degradation (return cached data on failure)

---

## Architecture

```
lib/core/
├── network/
│   ├── api_client.dart              # Base API client with HTTP methods
│   ├── api_providers.dart           # Riverpod providers for API calls
│   ├── capture_api_client.dart      # Abstract API interface
│   ├── dio_capture_api_client.dart  # Real Dio implementation
│   ├── dio_interceptors.dart        # All interceptors
│   ├── dio_provider.dart            # Dio instance provider
│   ├── mock_capture_api_client.dart # Mock implementation for testing
│   ├── network_manager.dart         # Network state & cancellation
│   ├── network.dart                 # Exports all network modules
│   └── USAGE_EXAMPLES.dart          # Comprehensive usage examples
│
└── cache/
    └── cache_service.dart           # Hive-based cache service
```

---

## Quick Start

### 1. Basic API Call with Auto Network Checking

```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simpliid/core/network/network.dart';

class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // Automatically checks network before making request
        final response = await ref.read(loginProvider(
          LoginRequest(username: 'user', password: 'pass'),
        ).future);
        
        if (response.status == 'success') {
          print('Token: ${response.data?.token}');
        }
      },
      child: Text('Login'),
    );
  }
}
```

### 2. Cached API Call (Offline Support)

```dart
class StudentsListWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(cachedFetchStudentsProvider(
      FetchStudentsRequest(orderId: '1001', page: 1),
    ));

    return studentsAsync.when(
      data: (response) => ListView.builder(
        itemCount: response.students.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(response.students[index].name),
        ),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 3. FormData Upload with Progress

```dart
class UploadWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.watch(apiClientProvider);
    final progress = useState(0.0);

    return Column(
      children: [
        LinearProgressIndicator(value: progress.value),
        ElevatedButton(
          onPressed: () async {
            final formData = FormData.fromMap({
              'name': 'John Doe',
              'file': await MultipartFile.fromFile(
                '/path/to/photo.jpg',
                filename: 'photo.jpg',
              ),
            });

            await apiClient.postFormData(
              'https://api.example.com/upload',
              formData: formData,
              onSendProgress: (sent, total) {
                progress.value = sent / total;
              },
            );
          },
          child: Text('Upload'),
        ),
      ],
    );
  }
}
```

### 4. Network Status Monitoring

```dart
class NetworkStatusWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnectedAsync = ref.watch(isConnectedProvider);

    return isConnectedAsync.when(
      data: (isConnected) => Container(
        color: isConnected ? Colors.green : Colors.red,
        child: Text(
          isConnected ? 'Online' : 'Offline',
          style: TextStyle(color: Colors.white),
        ),
      ),
      loading: () => CircularProgressIndicator(),
      error: (_, __) => Icon(Icons.error),
    );
  }
}
```

### 5. Manual Request Cancellation

```dart
class CancellableRequestWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.watch(apiClientProvider);
    final networkManager = ref.watch(networkManagerProvider);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final cancelToken = networkManager.createCancelToken('myRequest');
            
            try {
              final response = await apiClient.get(
                'https://api.example.com/data',
                cancelToken: cancelToken,
              );
              print('Data: ${response.data}');
            } finally {
              networkManager.removeCancelToken('myRequest');
            }
          },
          child: Text('Start Request'),
        ),
        ElevatedButton(
          onPressed: () => networkManager.cancelRequest('myRequest'),
          child: Text('Cancel Request'),
        ),
      ],
    );
  }
}
```

---

## Configuration

### Switch Between Mock and Real API

In `lib/core/network/api_providers.dart`:

```dart
final apiConfigProvider = Provider<ApiConfig>((ref) {
  return const ApiConfig(
    baseUrl: 'https://api.example.com/v1',
    useMockApi: false, // true for development, false for production
  );
});
```

### Customize Retry Behavior

In `lib/core/network/dio_provider.dart`:

```dart
RetryInterceptor(
  maxRetries: 3,              // Number of retry attempts
  retryDelay: Duration(seconds: 1), // Initial delay (exponential backoff)
),
```

### Customize Timeouts

In `lib/core/network/dio_provider.dart`:

```dart
BaseOptions(
  connectTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(seconds: 30),
  sendTimeout: Duration(seconds: 30),
),
```

---

## Cache Management

### Save to Cache

```dart
final cacheService = ref.watch(cacheServiceProvider);

await cacheService.save(
  'my_key',
  {'data': 'value'},
  expiration: Duration(hours: 1), // Optional
);
```

### Get from Cache

```dart
final data = cacheService.get<Map<String, dynamic>>('my_key');
```

### Check Cache Exists

```dart
final exists = cacheService.has('my_key');
```

### Clear Specific Cache

```dart
await cacheService.remove('my_key');
```

### Clear All Cache

```dart
await cacheService.clear();
```

### Clear Expired Entries

```dart
await cacheService.clearExpired();
```

---

## Error Handling

### NoInternetException

Thrown when there's no internet connection:

```dart
try {
  await apiClient.get('/data');
} on DioException catch (e) {
  if (e.error is NoInternetException) {
    print('No internet connection');
  }
}
```

### User-Friendly Error Messages

The `DioCaptureApiClient` automatically converts Dio errors to user-friendly messages:

- Connection timeout → "Connection timeout. Please check your internet connection."
- Network error → "Connection failed. Please check your internet."
- Server error → "Server error (500)"
- Request cancelled → "Request cancelled"

---

## Testing

### Using Mock API

The `MockCaptureApiClient` provides realistic mock data for testing:

```dart
// Set useMockApi: true in apiConfigProvider
final apiClient = MockCaptureApiClient();

final response = await apiClient.login(
  LoginRequest(username: 'test', password: 'test'),
);

print(response.data?.token); // Returns mock token
```

---

## Best Practices

1. **Always use providers** instead of creating Dio instances manually
2. **Use cached providers** for data that doesn't change frequently
3. **Tag requests** with meaningful names for easier cancellation
4. **Clean up cancel tokens** after request completion
5. **Handle errors gracefully** and provide feedback to users
6. **Clear expired cache** periodically to save storage
7. **Monitor network status** for better UX

---

## Migration Guide

### From Old Code

**Before:**
```dart
final dio = Dio();
final response = await dio.get('https://api.example.com/data');
```

**After:**
```dart
final apiClient = ref.watch(apiClientProvider);
final response = await apiClient.get('https://api.example.com/data');
```

---

## Performance Considerations

- **Retry interceptor** adds exponential backoff delays (1s, 2s, 4s)
- **Cache expiration** runs on-demand, not automatically
- **Network monitoring** uses native connectivity checks (minimal overhead)
- **Request cancellation** is immediate and prevents network waste

---

## Troubleshooting

### Requests Not Completing

1. Check network status: `networkManager.isCurrentlyConnected`
2. Verify base URL in `apiConfigProvider`
3. Check if request was cancelled
4. Increase timeout values

### Cache Not Working

1. Ensure Hive is initialized: `Hive.initFlutter()`
2. Check if cache box is opened
3. Verify cache key is correct
4. Check if cache has expired

### Offline Mode Not Working

1. Use `cachedFetchStudentsProvider` instead of direct API calls
2. Ensure data was cached before going offline
3. Check cache expiration time

---

## Dependencies

```yaml
dependencies:
  dio: ^5.4.0
  connectivity_plus: ^5.0.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_riverpod: ^2.4.0
```

---

## Future Enhancements

- [ ] Request queue for offline sync
- [ ] GraphQL support
- [ ] WebSocket integration
- [ ] Advanced cache strategies (LRU, size-based)
- [ ] Metrics and analytics
- [ ] Request deduplication
