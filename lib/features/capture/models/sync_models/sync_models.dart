import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_models.freezed.dart';
part 'sync_models.g.dart';

@freezed
abstract class SyncStudentMetadata with _$SyncStudentMetadata {
  const factory SyncStudentMetadata({
    required String studentId,
    required DateTime captureTimestamp,
    required int editedBy,
    required int status,
    required String thumbnailBase64,
    required bool hasHighResUpdate,
  }) = _SyncStudentMetadata;

  factory SyncStudentMetadata.fromJson(Map<String, dynamic> json) =>
      _$SyncStudentMetadataFromJson(json);
}

class SyncBatchRequest {
  SyncBatchRequest({
    required this.orderId,
    required this.students,
    required this.highResFilePaths,
  });

  final String orderId;
  final List<SyncStudentMetadata> students;

  /// Key: student_id, Value: local file path for the high-res image.
  final Map<String, String> highResFilePaths;
}

@freezed
abstract class SyncFailedId with _$SyncFailedId {
  const factory SyncFailedId({
    required String studentId,
    required String error,
  }) = _SyncFailedId;

  factory SyncFailedId.fromJson(Map<String, dynamic> json) =>
      _$SyncFailedIdFromJson(json);
}

@freezed
abstract class SyncBatchResponse with _$SyncBatchResponse {
  const factory SyncBatchResponse({
    required String status,
    @Default([]) List<SyncFailedId> failedIds,
  }) = _SyncBatchResponse;

  factory SyncBatchResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncBatchResponseFromJson(json);
}
