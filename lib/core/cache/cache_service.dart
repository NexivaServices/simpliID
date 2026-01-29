import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cache service for storing API responses and other data
class CacheService {
  CacheService({required this.box});

  final Box<dynamic> box;

  /// Save data to cache with optional expiration
  Future<void> save(
    String key,
    dynamic value, {
    Duration? expiration,
  }) async {
    final cacheEntry = {
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiration': expiration?.inMilliseconds,
    };
    await box.put(key, cacheEntry);
  }

  /// Get data from cache
  T? get<T>(String key) {
    final cacheEntry = box.get(key) as Map<dynamic, dynamic>?;
    if (cacheEntry == null) return null;

    final timestamp = cacheEntry['timestamp'] as int;
    final expiration = cacheEntry['expiration'] as int?;

    // Check if cache has expired
    if (expiration != null) {
      final expirationTime = timestamp + expiration;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now > expirationTime) {
        // Cache expired, remove it
        box.delete(key);
        return null;
      }
    }

    return cacheEntry['value'] as T?;
  }

  /// Check if cache exists and is valid
  bool has(String key) {
    final cacheEntry = box.get(key) as Map<dynamic, dynamic>?;
    if (cacheEntry == null) return false;

    final timestamp = cacheEntry['timestamp'] as int;
    final expiration = cacheEntry['expiration'] as int?;

    if (expiration != null) {
      final expirationTime = timestamp + expiration;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now > expirationTime) {
        box.delete(key);
        return false;
      }
    }

    return true;
  }

  /// Remove specific cache entry
  Future<void> remove(String key) async {
    await box.delete(key);
  }

  /// Clear all cache
  Future<void> clear() async {
    await box.clear();
  }

  /// Clear expired cache entries
  Future<void> clearExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final keysToDelete = <String>[];

    for (final key in box.keys) {
      final cacheEntry = box.get(key) as Map<dynamic, dynamic>?;
      if (cacheEntry != null) {
        final timestamp = cacheEntry['timestamp'] as int;
        final expiration = cacheEntry['expiration'] as int?;

        if (expiration != null) {
          final expirationTime = timestamp + expiration;
          if (now > expirationTime) {
            keysToDelete.add(key as String);
          }
        }
      }
    }

    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }

  /// Get cache size in bytes (approximate)
  int get size {
    var totalSize = 0;
    for (final value in box.values) {
      // Rough estimation
      totalSize += value.toString().length;
    }
    return totalSize;
  }

  /// Get number of cached items
  int get length => box.length;
}

/// Provider for cache box
final cacheBoxProvider = FutureProvider<Box<dynamic>>((ref) async {
  return Hive.openBox('api_cache');
});

/// Provider for cache service
final cacheServiceProvider = Provider<CacheService>((ref) {
  final boxAsync = ref.watch(cacheBoxProvider);
  return boxAsync.when(
    data: (box) => CacheService(box: box),
    loading: () => throw Exception('Cache not initialized'),
    error: (error, stack) => throw error,
  );
});
