import 'package:freezed_annotation/freezed_annotation.dart';

import '../capture_student/capture_student.dart';

part 'fetch_models.freezed.dart';
part 'fetch_models.g.dart';

@freezed
abstract class FetchStudentsRequest with _$FetchStudentsRequest {
  const factory FetchStudentsRequest({
    required String orderId,
    DateTime? lastSyncTimestamp,
    int? page,
    int? pageSize,
  }) = _FetchStudentsRequest;

  factory FetchStudentsRequest.fromJson(Map<String, dynamic> json) =>
      _$FetchStudentsRequestFromJson(json);
}

@freezed
abstract class FetchStudentsResponse with _$FetchStudentsResponse {
  const factory FetchStudentsResponse({
    required String status,
    required String orderId,
    required DateTime serverSyncTimestamp,
    required List<CaptureStudent> students,
    // Pagination (extension beyond the PDF spec, required by app infinite-scroll).
    required int page,
    required int pageSize,
    required int totalStudents,
    // Extra order/school details requested.
    @Default({}) Map<String, dynamic> details,
  }) = _FetchStudentsResponse;

  factory FetchStudentsResponse.fromJson(Map<String, dynamic> json) =>
      _$FetchStudentsResponseFromJson(json);
}
