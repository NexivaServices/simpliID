// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncStudentMetadata _$SyncStudentMetadataFromJson(Map<String, dynamic> json) =>
    _SyncStudentMetadata(
      studentId: json['studentId'] as String,
      captureTimestamp: DateTime.parse(json['captureTimestamp'] as String),
      editedBy: (json['editedBy'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      thumbnailBase64: json['thumbnailBase64'] as String,
      hasHighResUpdate: json['hasHighResUpdate'] as bool,
    );

Map<String, dynamic> _$SyncStudentMetadataToJson(
  _SyncStudentMetadata instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'captureTimestamp': instance.captureTimestamp.toIso8601String(),
  'editedBy': instance.editedBy,
  'status': instance.status,
  'thumbnailBase64': instance.thumbnailBase64,
  'hasHighResUpdate': instance.hasHighResUpdate,
};

_SyncFailedId _$SyncFailedIdFromJson(Map<String, dynamic> json) =>
    _SyncFailedId(
      studentId: json['studentId'] as String,
      error: json['error'] as String,
    );

Map<String, dynamic> _$SyncFailedIdToJson(_SyncFailedId instance) =>
    <String, dynamic>{'studentId': instance.studentId, 'error': instance.error};

_SyncBatchResponse _$SyncBatchResponseFromJson(Map<String, dynamic> json) =>
    _SyncBatchResponse(
      status: json['status'] as String,
      failedIds:
          (json['failedIds'] as List<dynamic>?)
              ?.map((e) => SyncFailedId.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SyncBatchResponseToJson(_SyncBatchResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'failedIds': instance.failedIds,
    };
