import 'package:freezed_annotation/freezed_annotation.dart';

import '../sync_status.dart';

part 'capture_student.freezed.dart';
part 'capture_student.g.dart';

@freezed
abstract class CaptureStudent with _$CaptureStudent {
  const factory CaptureStudent({
    required String orderId,
    required String studentId,
    required String admNo,
    required String name,
    required int status,
    required DateTime updatedAt,
    required Map<String, dynamic> details,
    String? photoUrl,
    String? thumbnailUrl,
    DateTime? captureTimestamp,
    int? editedBy,
    String? localHighResPath,
    String? localThumbnailPath,
    @Default(SyncStatus.synced) SyncStatus syncStatus,
    @Default(false) bool isLocalNew,
  }) = _CaptureStudent;

  factory CaptureStudent.fromJson(Map<String, dynamic> json) =>
      _$CaptureStudentFromJson(json);
}
