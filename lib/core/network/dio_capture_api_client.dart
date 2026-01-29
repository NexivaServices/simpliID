import 'package:dio/dio.dart';

import '../../features/capture/models/models.dart';
import 'api_client.dart';
import 'capture_api_client.dart';
import 'dio_interceptors.dart';
import 'network_manager.dart';

/// Real implementation of CaptureApiClient using Dio
class DioCaptureApiClient implements CaptureApiClient {
  DioCaptureApiClient({
    required this.apiClient,
    required this.networkManager,
    required this.baseUrl,
  });

  final ApiClient apiClient;
  final NetworkManager networkManager;
  final String baseUrl;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      // Check network connectivity first
      if (!await networkManager.isConnected()) {
        throw const NoInternetException('No internet connection');
      }

      final cancelToken = networkManager.createCancelToken('login');

      final response = await apiClient.post<Map<String, dynamic>>(
        '$baseUrl/auth/login',
        data: {
          'username': request.username,
          'password': request.password,
        },
        cancelToken: cancelToken,
      );

      networkManager.removeCancelToken('login');

      if (response.statusCode == 200 && response.data != null) {
        return LoginResponse.fromJson(response.data!);
      } else {
        return LoginResponse(
          status: 'error',
          data: null,
          message: response.data?['message'] as String? ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      return LoginResponse(
        status: 'error',
        data: null,
        message: _handleDioError(e),
      );
    } catch (e) {
      return LoginResponse(
        status: 'error',
        data: null,
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<FetchStudentsResponse> fetchStudents(
    FetchStudentsRequest request,
  ) async {
    try {
      if (!await networkManager.isConnected()) {
        throw const NoInternetException('No internet connection');
      }

      final cancelToken = networkManager.createCancelToken('fetchStudents');

      final response = await apiClient.get<Map<String, dynamic>>(
        '$baseUrl/orders/${request.orderId}/students',
        queryParameters: {
          'page': request.page ?? 1,
          'page_size': request.pageSize ?? 50,
        },
        cancelToken: cancelToken,
      );

      networkManager.removeCancelToken('fetchStudents');

      if (response.statusCode == 200 && response.data != null) {
        return FetchStudentsResponse.fromJson(response.data!);
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to fetch students');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  @override
  Future<SyncBatchResponse> syncBatch(SyncBatchRequest request) async {
    try {
      if (!await networkManager.isConnected()) {
        throw const NoInternetException('No internet connection');
      }

      // Create multipart form data
      final formData = FormData();

      // Add order_id
      formData.fields.add(MapEntry('order_id', request.orderId));

      // Add student data and photos
      for (var i = 0; i < request.students.length; i++) {
        final student = request.students[i];

        // Add student metadata
        formData.fields.addAll([
          MapEntry('students[$i][student_id]', student.studentId),
          MapEntry(
            'students[$i][capture_timestamp]',
            student.captureTimestamp.toIso8601String(),
          ),
          MapEntry('students[$i][edited_by]', student.editedBy.toString()),
          MapEntry('students[$i][status]', student.status.toString()),
          MapEntry('students[$i][thumbnail_base64]', student.thumbnailBase64),
          MapEntry('students[$i][has_high_res_update]', student.hasHighResUpdate.toString()),
        ]);

        // Add high-res photo file if available
        final highResPath = request.highResFilePaths[student.studentId];
        if (highResPath != null && student.hasHighResUpdate) {
          formData.files.add(
            MapEntry(
              'students[$i][photo]',
              await MultipartFile.fromFile(
                highResPath,
                filename: '${student.studentId}.jpg',
              ),
            ),
          );
        }
      }

      final cancelToken = networkManager.createCancelToken('syncBatch_${request.orderId}');

      final response = await apiClient.postFormData<Map<String, dynamic>>(
        '$baseUrl/students/sync-batch',
        formData: formData,
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          // Can emit progress events here for UI
          if (total != -1) {
            // final progress = (sent / total * 100).toInt();
            // print('Upload progress: $progress%');
          }
        },
      );

      networkManager.removeCancelToken('syncBatch_${request.orderId}');

      if (response.statusCode == 200 && response.data != null) {
        return SyncBatchResponse.fromJson(response.data!);
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to sync batch');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Handle Dio errors and return user-friendly messages
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] as String?;
        return message ?? 'Server error ($statusCode)';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        if (error.error is NoInternetException) {
          return (error.error as NoInternetException).message;
        } else {
          return 'Connection failed. Please check your internet.';
        }
      case DioExceptionType.badCertificate:
        return 'Security certificate error';
      case DioExceptionType.unknown:
        return error.message ?? 'Unknown error occurred';
    }
  }

  /// Cancel ongoing sync operation
  void cancelSync(String orderId) {
    networkManager.cancelRequest('syncBatch_$orderId');
  }

  /// Cancel all ongoing requests
  void cancelAllRequests() {
    networkManager.cancelAllRequests();
  }
}
