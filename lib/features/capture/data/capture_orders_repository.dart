import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import '../../../core/image/passport_crop_detector.dart';
import '../../../core/network/capture_api_client.dart';
import '../../../core/storage/photo_storage.dart';
import '../models/models.dart';
import 'capture_cache_repository.dart';

class CaptureOrdersRepository {
  CaptureOrdersRepository({
    required this.api,
    required this.cache,
    required this.uuid,
    required this.photoStorage,
    required this.passportCropDetector,
  });

  final CaptureApiClient api;
  final CaptureCacheRepository cache;
  final Uuid uuid;
  final PhotoStorage photoStorage;
  final PassportCropDetector passportCropDetector;

  Future<FetchStudentsResponse> fetchStudentsPage({
    required String orderId,
    required bool online,
    required int page,
    required int pageSize,
    DateTime? lastSyncTimestamp,
  }) async {
    if (online) {
      final response = await api.fetchStudents(
        FetchStudentsRequest(
          orderId: orderId,
          lastSyncTimestamp: lastSyncTimestamp,
          page: page,
          pageSize: pageSize,
        ),
      );

      await cache.upsertStudentsBatch(orderId, response.students);
      await cache.writeOrderMeta(orderId, {
        'server_sync_timestamp': response.serverSyncTimestamp.toIso8601String(),
        'total_students': response.totalStudents,
        'details': response.details,
      });

      return response;
    }

    // Offline: serve from cache.
    final offset = (page - 1) * pageSize;
    final students = await cache.getStudentsPage(
      orderId,
      offset: offset,
      limit: pageSize,
    );
    final meta = await cache.readOrderMeta(orderId);

    final totalStudents =
        (meta['total_students'] as int?) ?? await cache.getCachedCount(orderId);
    final serverSyncTimestamp =
        DateTime.tryParse((meta['server_sync_timestamp'] as String?) ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

    return FetchStudentsResponse(
      status: 'success',
      orderId: orderId,
      serverSyncTimestamp: serverSyncTimestamp,
      students: students,
      page: page,
      pageSize: pageSize,
      totalStudents: totalStudents,
      details: (meta['details'] is Map)
          ? Map<String, dynamic>.from(meta['details'] as Map)
          : const {},
    );
  }

  Future<CaptureStudent> addLocalStudent({
    required String orderId,
    required String admNo,
    required String name,
  }) async {
    final studentId = 'local_${uuid.v4()}';
    final now = DateTime.now().toUtc();

    final student = CaptureStudent(
      orderId: orderId,
      studentId: studentId,
      admNo: admNo,
      name: name,
      status: 1,
      updatedAt: now,
      details: {
        'student_id': studentId,
        'adm_no': admNo,
        'name': name,
        'order_id': orderId,
        'is_local_new': true,
        'updated_at': now.toIso8601String(),
      },
      syncStatus: SyncStatus.pending,
      isLocalNew: true,
    );

    await cache.upsertStudent(student);
    return student;
  }

  Future<CaptureStudent> markCaptured({
    required String orderId,
    required String studentId,
    required int editedBy,
  }) async {
    final existing = await cache.readStudent(orderId, studentId);
    if (existing == null) {
      throw StateError('Student not found in cache');
    }

    final photos = await photoStorage.writeDummyPhotos(
      orderId: orderId,
      studentId: studentId,
    );
    final crop = await passportCropDetector.suggestCrop(
      imagePath: photos.highResPath,
    );
    return markCapturedWithLocalPhotos(
      orderId: orderId,
      studentId: studentId,
      editedBy: editedBy,
      localHighResPath: photos.highResPath,
      localThumbnailPath: photos.thumbnailPath,
      crop: crop,
    );
  }

  Future<CaptureStudent> markCapturedWithLocalPhotos({
    required String orderId,
    required String studentId,
    required int editedBy,
    required String localHighResPath,
    required String localThumbnailPath,
    Rect? crop,
  }) async {
    final existing = await cache.readStudent(orderId, studentId);
    if (existing == null) {
      throw StateError('Student not found in cache');
    }

    final now = DateTime.now().toUtc();

    final cropJson = (crop == null)
        ? null
        : <String, dynamic>{
            'left': crop.left,
            'top': crop.top,
            'right': crop.right,
            'bottom': crop.bottom,
            'aspect': 35 / 45,
          };

    // Kick off background compress+encrypt at rest (do not block UI).
    final encPath = await photoStorage.scheduleCompressAndEncrypt(
      orderId: orderId,
      studentId: studentId,
      inputJpgPath: localHighResPath,
    );

    final updated = existing.copyWith(
      captureTimestamp: now,
      editedBy: editedBy,
      localHighResPath: localHighResPath,
      localThumbnailPath: localThumbnailPath,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
      details: {
        ...existing.details,
        'capture_timestamp': now.toIso8601String(),
        'edited_by': editedBy,
        'thumbnail_url': existing.thumbnailUrl,
        'photo_url': existing.photoUrl,
        'updated_at': now.toIso8601String(),
        'absent': false,
        'local_high_res_encrypted_path': encPath,
        if (cropJson != null) 'passport_crop': cropJson,
      },
    );

    await cache.upsertStudent(updated);
    return updated;
  }

  Future<CaptureStudent> markAbsent({
    required String orderId,
    required String studentId,
    required int editedBy,
  }) async {
    final existing = await cache.readStudent(orderId, studentId);
    if (existing == null) {
      throw StateError('Student not found in cache');
    }

    final now = DateTime.now().toUtc();
    final updated = existing.copyWith(
      captureTimestamp: now,
      editedBy: editedBy,
      localHighResPath: null,
      localThumbnailPath: null,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
      details: {
        ...existing.details,
        'capture_timestamp': now.toIso8601String(),
        'edited_by': editedBy,
        'updated_at': now.toIso8601String(),
        'absent': true,
      },
    );

    await cache.upsertStudent(updated);
    return updated;
  }
}
