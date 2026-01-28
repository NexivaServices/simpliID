import '../../features/capture/models/models.dart';

abstract interface class CaptureApiClient {
  Future<LoginResponse> login(LoginRequest request);

  Future<FetchStudentsResponse> fetchStudents(FetchStudentsRequest request);

  /// Mimics: POST /api/v1/students/sync-batch (multipart on real backend).
  Future<SyncBatchResponse> syncBatch(SyncBatchRequest request);
}
