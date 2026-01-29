import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../connectivity/connectivity_providers.dart';

/// Network manager for handling network state and request cancellation
class NetworkManager {
  NetworkManager({
    required this.connectivity,
  }) {
    _initialize();
  }

  final Connectivity connectivity;
  final _cancelTokens = <String, CancelToken>{};
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = true;

  void _initialize() {
    // Listen to connectivity changes
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((results) {
      final wasConnected = _isConnected;
      _isConnected = !results.contains(ConnectivityResult.none);

      // Cancel all ongoing requests if connection is lost
      if (wasConnected && !_isConnected) {
        cancelAllRequests('Connection lost');
      }
    });

    // Check initial connectivity
    connectivity.checkConnectivity().then((results) {
      _isConnected = !results.contains(ConnectivityResult.none);
    });
  }

  /// Check if device is connected to internet
  Future<bool> isConnected() async {
    final results = await connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  /// Get current connectivity status
  bool get isCurrentlyConnected => _isConnected;

  /// Create a cancel token for a request
  CancelToken createCancelToken(String tag) {
    final token = CancelToken();
    _cancelTokens[tag] = token;
    return token;
  }

  /// Cancel a specific request by tag
  void cancelRequest(String tag, [String? reason]) {
    final token = _cancelTokens[tag];
    if (token != null && !token.isCancelled) {
      token.cancel(reason ?? 'Request cancelled');
      _cancelTokens.remove(tag);
    }
  }

  /// Cancel all ongoing requests
  void cancelAllRequests([String? reason]) {
    for (final entry in _cancelTokens.entries) {
      if (!entry.value.isCancelled) {
        entry.value.cancel(reason ?? 'All requests cancelled');
      }
    }
    _cancelTokens.clear();
  }

  /// Remove cancel token after request completion
  void removeCancelToken(String tag) {
    _cancelTokens.remove(tag);
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    cancelAllRequests('Network manager disposed');
  }
}

/// Provider for network manager
final networkManagerProvider = Provider<NetworkManager>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  final manager = NetworkManager(connectivity: connectivity);
  ref.onDispose(() => manager.dispose());
  return manager;
});

/// Provider for current network status
final isConnectedProvider = StreamProvider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.onConnectivityChanged.map(
    (results) => !results.contains(ConnectivityResult.none),
  );
});
