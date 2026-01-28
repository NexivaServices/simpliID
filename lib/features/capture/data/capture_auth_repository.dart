import '../models/models.dart';
import '../../../core/network/capture_api_client.dart';
import 'capture_cache_repository.dart';

class CaptureAuthRepository {
  CaptureAuthRepository({required this.api, required this.cache});

  final CaptureApiClient api;
  final CaptureCacheRepository cache;

  Future<Session> loginOnline({
    required String username,
    required String password,
    String? deviceId,
  }) async {
    final response = await api.login(
      LoginRequest(username: username, password: password, deviceId: deviceId),
    );

    final data = response.data;
    if (response.status != 'success' || data == null) {
      throw StateError(response.message ?? 'Login failed');
    }

    final session = Session(
      username: username,
      password: password,
      userId: data.userId,
      token: data.token,
      orderIds: data.orderIds,
      loggedInAt: DateTime.now().toUtc(),
    );

    await cache.writeSession(session);
    return session;
  }

  Future<Session?> tryOfflineLogin({
    required String username,
    required String password,
  }) async {
    final existing = await cache.readSession();
    if (existing == null) return null;

    if (existing.username == username && existing.password == password) {
      return existing;
    }

    return null;
  }

  Future<void> logout() async {
    await cache.clearSession();
  }
}
