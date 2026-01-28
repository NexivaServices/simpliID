import '../../../core/network/capture_api_client.dart';
import '../../../core/storage/photo_storage.dart';
import '../models/models.dart';
import 'capture_cache_repository.dart';

class CaptureSyncRepository {
  CaptureSyncRepository({
    required this.api,
    required this.cache,
    required this.photoStorage,
  });

  final CaptureApiClient api;
  final CaptureCacheRepository cache;
  final PhotoStorage photoStorage;

  /// Synces up to 10 students at a time (per spec: multipart batching 10-20).
  Future<SyncBatchResponse?> syncNextChunk({
    required String orderId,
    required int editedBy,
  }) async {
    final pendingIds = await cache.getPendingStudentIds(orderId, limit: 10);
    if (pendingIds.isEmpty) return null;

    final students = <SyncStudentMetadata>[];
    final highResPaths = <String, String>{};

    for (final id in pendingIds) {
      final s = await cache.readStudent(orderId, id);
      if (s == null) continue;

      final captureTs = s.captureTimestamp;
      final thumbPath = s.localThumbnailPath;
      if (captureTs == null || thumbPath == null) {
        // Not ready to upload yet; keep pending.
        continue;
      }

      final thumbB64 = await photoStorage.readFileBase64(thumbPath);
      final hasHigh = (s.localHighResPath != null);
      if (hasHigh) {
        highResPaths[id] = s.localHighResPath!;
      }

      students.add(
        SyncStudentMetadata(
          studentId: id,
          captureTimestamp: captureTs,
          editedBy: editedBy,
          status: s.status,
          thumbnailBase64: thumbB64,
          hasHighResUpdate: hasHigh,
        ),
      );
    }

    if (students.isEmpty) return null;

    final response = await api.syncBatch(
      SyncBatchRequest(
        orderId: orderId,
        students: students,
        highResFilePaths: highResPaths,
      ),
    );

    final failedIds = {
      for (final f in response.failedIds) f.studentId: f.error,
    };
    final attemptedIds = students.map((e) => e.studentId).toSet();
    final successIds = attemptedIds
        .where((id) => !failedIds.containsKey(id))
        .toList();

    if (successIds.isNotEmpty) {
      await cache.markStudentsSynced(orderId, successIds);
    }
    if (failedIds.isNotEmpty) {
      await cache.markStudentsFailed(orderId, failedIds);
    }

    return response;
  }
}
