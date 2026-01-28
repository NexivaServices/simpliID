import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/connectivity/connectivity_providers.dart';
import '../../../core/network/capture_api_client.dart';
import '../../../core/network/mock_capture_api_client.dart';
import '../../../core/image/passport_crop_detector.dart';
import '../../../core/storage/photo_storage.dart';
import '../data/capture_auth_repository.dart';
import '../data/capture_cache_repository.dart';
import '../data/capture_orders_repository.dart';
import '../data/capture_sync_repository.dart';
import '../models/models.dart';

final photoStorageProvider = Provider<PhotoStorage>((ref) => PhotoStorage());

final passportCropDetectorProvider = Provider<PassportCropDetector>((ref) {
  final detector = PassportCropDetector();
  ref.onDispose(() {
    // ignore: discarded_futures
    detector.dispose();
  });
  return detector;
});

final uuidProvider = Provider<Uuid>((ref) => const Uuid());

final captureApiClientProvider = Provider<CaptureApiClient>(
  (ref) => MockCaptureApiClient(),
);

final captureCacheRepositoryProvider = Provider<CaptureCacheRepository>(
  (ref) => CaptureCacheRepository(),
);

final captureAuthRepositoryProvider = Provider<CaptureAuthRepository>((ref) {
  return CaptureAuthRepository(
    api: ref.watch(captureApiClientProvider),
    cache: ref.watch(captureCacheRepositoryProvider),
  );
});

final captureOrdersRepositoryProvider = Provider<CaptureOrdersRepository>((
  ref,
) {
  return CaptureOrdersRepository(
    api: ref.watch(captureApiClientProvider),
    cache: ref.watch(captureCacheRepositoryProvider),
    uuid: ref.watch(uuidProvider),
    photoStorage: ref.watch(photoStorageProvider),
    passportCropDetector: ref.watch(passportCropDetectorProvider),
  );
});

final captureSyncRepositoryProvider = Provider<CaptureSyncRepository>((ref) {
  return CaptureSyncRepository(
    api: ref.watch(captureApiClientProvider),
    cache: ref.watch(captureCacheRepositoryProvider),
    photoStorage: ref.watch(photoStorageProvider),
  );
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityResultsProvider);
  return connectivity.maybeWhen(
    data: (results) {
      if (results.isEmpty) return false;
      if (results.contains(ConnectivityResult.none)) return false;
      return true;
    },
    orElse: () => false,
  );
});

class SessionNotifier extends Notifier<Session?> {
  @override
  Session? build() {
    return ref.read(captureCacheRepositoryProvider).readSessionSync();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final auth = ref.read(captureAuthRepositoryProvider);
    final online = ref.read(isOnlineProvider);

    final s = online
        ? await auth.loginOnline(username: username, password: password)
        : await auth.tryOfflineLogin(username: username, password: password);
    if (s == null) {
      throw StateError('Offline login unavailable. Please login once online.');
    }
    state = s;
  }

  Future<void> logout() async {
    await ref.read(captureAuthRepositoryProvider).logout();
    state = null;
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, Session?>(
  SessionNotifier.new,
);
