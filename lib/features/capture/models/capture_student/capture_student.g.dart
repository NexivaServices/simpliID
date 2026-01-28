// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CaptureStudent _$CaptureStudentFromJson(Map<String, dynamic> json) =>
    _CaptureStudent(
      orderId: json['orderId'] as String,
      studentId: json['studentId'] as String,
      admNo: json['admNo'] as String,
      name: json['name'] as String,
      status: (json['status'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      details: json['details'] as Map<String, dynamic>,
      photoUrl: json['photoUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      captureTimestamp: json['captureTimestamp'] == null
          ? null
          : DateTime.parse(json['captureTimestamp'] as String),
      editedBy: (json['editedBy'] as num?)?.toInt(),
      localHighResPath: json['localHighResPath'] as String?,
      localThumbnailPath: json['localThumbnailPath'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
          SyncStatus.synced,
      isLocalNew: json['isLocalNew'] as bool? ?? false,
    );

Map<String, dynamic> _$CaptureStudentToJson(_CaptureStudent instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'studentId': instance.studentId,
      'admNo': instance.admNo,
      'name': instance.name,
      'status': instance.status,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'details': instance.details,
      'photoUrl': instance.photoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'captureTimestamp': instance.captureTimestamp?.toIso8601String(),
      'editedBy': instance.editedBy,
      'localHighResPath': instance.localHighResPath,
      'localThumbnailPath': instance.localThumbnailPath,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'isLocalNew': instance.isLocalNew,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pending: 'pending',
  SyncStatus.failed: 'failed',
};
