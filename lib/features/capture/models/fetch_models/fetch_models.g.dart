// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FetchStudentsRequest _$FetchStudentsRequestFromJson(
  Map<String, dynamic> json,
) => _FetchStudentsRequest(
  orderId: json['orderId'] as String,
  lastSyncTimestamp: json['lastSyncTimestamp'] == null
      ? null
      : DateTime.parse(json['lastSyncTimestamp'] as String),
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
);

Map<String, dynamic> _$FetchStudentsRequestToJson(
  _FetchStudentsRequest instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'lastSyncTimestamp': instance.lastSyncTimestamp?.toIso8601String(),
  'page': instance.page,
  'pageSize': instance.pageSize,
};

_FetchStudentsResponse _$FetchStudentsResponseFromJson(
  Map<String, dynamic> json,
) => _FetchStudentsResponse(
  status: json['status'] as String,
  orderId: json['orderId'] as String,
  serverSyncTimestamp: DateTime.parse(json['serverSyncTimestamp'] as String),
  students: (json['students'] as List<dynamic>)
      .map((e) => CaptureStudent.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalStudents: (json['totalStudents'] as num).toInt(),
  details: json['details'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$FetchStudentsResponseToJson(
  _FetchStudentsResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'orderId': instance.orderId,
  'serverSyncTimestamp': instance.serverSyncTimestamp.toIso8601String(),
  'students': instance.students,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalStudents': instance.totalStudents,
  'details': instance.details,
};
