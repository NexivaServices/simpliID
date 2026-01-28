import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../features/capture/models/models.dart';
import 'capture_api_client.dart';

class MockCaptureApiClient implements CaptureApiClient {
  MockCaptureApiClient({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (request.username.trim().isEmpty || request.password.isEmpty) {
      return LoginResponse(
        status: 'error',
        data: null,
        message: 'Invalid credentials',
      );
    }

    final userId = _stableIntFromString(request.username) % 100000 + 1;

    return LoginResponse(
      status: 'success',
      data: LoginData(
        userId: userId,
        token: 'mock.${_uuid.v4().replaceAll('-', '')}',
        orderIds: const ['1001', '1002', '1003'],
      ),
      message: null,
    );
  }

  @override
  Future<FetchStudentsResponse> fetchStudents(
    FetchStudentsRequest request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final pageSize = request.pageSize ?? 50;
    final page = request.page ?? 1;

    // Spec says offline up to ~2,000 photos.
    const totalStudents = 2000;

    final startIndex = (page - 1) * pageSize;
    final endIndexExclusive = min(startIndex + pageSize, totalStudents);

    final students = <CaptureStudent>[];
    for (var index = startIndex; index < endIndexExclusive; index++) {
      final studentId = (index + 1).toString();
      final name = _fakeName(request.orderId, index);
      final updatedAt = DateTime.utc(2026, 1, 1).add(Duration(minutes: index));
      students.add(
        CaptureStudent(
          orderId: request.orderId,
          studentId: studentId,
          admNo:
              'ADM${request.orderId}-${(index + 1).toString().padLeft(4, '0')}',
          name: name,
          status: 1,
          updatedAt: updatedAt,
          photoUrl: 'uploads/${request.orderId}/$studentId.jpg',
          thumbnailUrl: 'uploads/${request.orderId}/${studentId}_thumb.jpg',
          captureTimestamp: null,
          editedBy: null,
          localHighResPath: null,
          localThumbnailPath: null,
          syncStatus: SyncStatus.synced,
          isLocalNew: false,
          details: {
            // From spec / normalized schema references.
            'student_id': int.tryParse(studentId) ?? studentId,
            'adm_no':
                'ADM${request.orderId}-${(index + 1).toString().padLeft(4, '0')}',
            'name': name,
            'order_id': request.orderId,
            'photo_url': 'uploads/${request.orderId}/$studentId.jpg',
            'thumbnail_url':
                'uploads/${request.orderId}/${studentId}_thumb.jpg',
            'status': 1,
            'updated_at': updatedAt.toIso8601String(),
            // Fields called out as mandatory for sync & audit.
            'capture_timestamp': null,
            'edited_by': null,
          },
        ),
      );
    }

    return FetchStudentsResponse(
      status: 'success',
      orderId: request.orderId,
      serverSyncTimestamp: DateTime.now().toUtc(),
      page: page,
      pageSize: pageSize,
      totalStudents: totalStudents,
      students: students,
      details: {
        'centre_code': request.orderId,
        'school_code': request.orderId,
        'school_name': 'Mock School ${request.orderId}',
      },
    );
  }

  @override
  Future<SyncBatchResponse> syncBatch(SyncBatchRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // 10% random failures (deterministic-ish by orderId).
    final rand = Random(
      _stableIntFromString('${request.orderId}:${request.students.length}'),
    );
    final failed = <SyncFailedId>[];
    for (final s in request.students) {
      if (rand.nextInt(10) == 0) {
        failed.add(
          SyncFailedId(studentId: s.studentId, error: 'File corrupted'),
        );
      }
    }

    return SyncBatchResponse(
      status: failed.isEmpty ? 'success' : 'partial_success',
      failedIds: failed,
    );
  }
}

int _stableIntFromString(String input) {
  var hash = 0;
  for (final codeUnit in input.codeUnits) {
    hash = 0x1fffffff & (hash + codeUnit);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    hash ^= (hash >> 6);
  }
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash ^= (hash >> 11);
  hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  return hash;
}

String _fakeName(String orderId, int index) {
  const first = [
    'Arun',
    'Asha',
    'Kiran',
    'Neha',
    'Rahul',
    'Priya',
    'Vikram',
    'Sana',
    'Imran',
    'Divya',
  ];
  const last = [
    'Kumar',
    'Singh',
    'Patel',
    'Sharma',
    'Reddy',
    'Nair',
    'Das',
    'Gupta',
    'Iyer',
    'Bose',
  ];
  final r = Random(_stableIntFromString('$orderId:$index'));
  return '${first[r.nextInt(first.length)]} ${last[r.nextInt(last.length)]}';
}
