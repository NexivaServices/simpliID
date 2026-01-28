import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/storage/hive_bootstrap.dart';
import '../models/models.dart';

class CaptureCacheRepository {
  Box<dynamic> get _box => Hive.box(HiveBoxes.secure);

  static const _sessionKey = 'capture:session';

  static String _orderMetaKey(String orderId) => 'capture:order:$orderId';

  static String _orderStudentsKey(String orderId) =>
      'capture:order_students:$orderId';

  static String _studentKey(String orderId, String studentId) =>
      'capture:student:$orderId:$studentId';

  static String _pendingKey(String orderId) => 'capture:pending:$orderId';

  Future<Session?> readSession() async {
    final raw = _box.get(_sessionKey);
    if (raw is Map) {
      return Session.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  Session? readSessionSync() {
    final raw = _box.get(_sessionKey);
    if (raw is Map) {
      return Session.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  Future<void> writeSession(Session session) async {
    await _box.put(_sessionKey, session.toJson());
  }

  Future<void> clearSession() async {
    await _box.delete(_sessionKey);
  }

  Future<Map<String, dynamic>> readOrderMeta(String orderId) async {
    final raw = _box.get(_orderMetaKey(orderId));
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return <String, dynamic>{};
  }

  Future<void> writeOrderMeta(String orderId, Map<String, dynamic> meta) async {
    await _box.put(_orderMetaKey(orderId), meta);
  }

  Future<List<String>> readOrderStudentIds(String orderId) async {
    final raw = _box.get(_orderStudentsKey(orderId));
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return <String>[];
  }

  Future<void> writeOrderStudentIds(String orderId, List<String> ids) async {
    await _box.put(_orderStudentsKey(orderId), ids);
  }

  Future<CaptureStudent?> readStudent(String orderId, String studentId) async {
    final raw = _box.get(_studentKey(orderId, studentId));
    if (raw is Map) {
      return CaptureStudent.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  Future<void> upsertStudent(CaptureStudent student) async {
    await _box.put(
      _studentKey(student.orderId, student.studentId),
      student.toJson(),
    );

    // Maintain the order index list.
    final ids = await readOrderStudentIds(student.orderId);
    if (!ids.contains(student.studentId)) {
      await writeOrderStudentIds(student.orderId, [...ids, student.studentId]);
    }

    // Maintain pending list.
    if (student.syncStatus == SyncStatus.pending ||
        student.syncStatus == SyncStatus.failed) {
      await _ensurePending(student.orderId, student.studentId);
    } else {
      await _removePending(student.orderId, student.studentId);
    }
  }

  Future<void> upsertStudentsBatch(
    String orderId,
    List<CaptureStudent> students,
  ) async {
    if (students.isEmpty) return;
    for (final student in students) {
      await _box.put(_studentKey(orderId, student.studentId), student.toJson());
    }

    final ids = await readOrderStudentIds(orderId);
    final merged = <String>[...ids];
    for (final student in students) {
      if (!merged.contains(student.studentId)) {
        merged.add(student.studentId);
      }
    }
    await writeOrderStudentIds(orderId, merged);
  }

  Future<List<CaptureStudent>> getStudentsPage(
    String orderId, {
    required int offset,
    required int limit,
  }) async {
    final ids = await readOrderStudentIds(orderId);
    if (ids.isEmpty) return <CaptureStudent>[];

    final start = offset.clamp(0, ids.length);
    final end = (offset + limit).clamp(0, ids.length);
    final pageIds = ids.sublist(start, end);

    final students = <CaptureStudent>[];
    for (final id in pageIds) {
      final s = await readStudent(orderId, id);
      if (s != null) {
        students.add(s);
      }
    }
    return students;
  }

  Future<int> getCachedCount(String orderId) async {
    final ids = await readOrderStudentIds(orderId);
    return ids.length;
  }

  Future<List<String>> getPendingStudentIds(
    String orderId, {
    int limit = 10,
  }) async {
    final raw = _box.get(_pendingKey(orderId));
    final ids = (raw is List)
        ? raw.map((e) => e.toString()).toList()
        : <String>[];
    if (ids.length <= limit) return ids;
    return ids.sublist(0, limit);
  }

  Future<void> markStudentsSynced(
    String orderId,
    List<String> studentIds,
  ) async {
    for (final id in studentIds) {
      final s = await readStudent(orderId, id);
      if (s == null) continue;
      await upsertStudent(s.copyWith(syncStatus: SyncStatus.synced));
    }
  }

  Future<void> markStudentsFailed(
    String orderId,
    Map<String, String> errorsById,
  ) async {
    for (final entry in errorsById.entries) {
      final s = await readStudent(orderId, entry.key);
      if (s == null) continue;
      // We keep the error inside details for now (UI can show it).
      final updatedDetails = {...s.details, 'sync_error': entry.value};
      await upsertStudent(
        s.copyWith(syncStatus: SyncStatus.failed, details: updatedDetails),
      );
    }
  }

  Future<void> _ensurePending(String orderId, String studentId) async {
    final raw = _box.get(_pendingKey(orderId));
    final ids = (raw is List)
        ? raw.map((e) => e.toString()).toList()
        : <String>[];
    if (!ids.contains(studentId)) {
      await _box.put(_pendingKey(orderId), [...ids, studentId]);
    }
  }

  Future<void> _removePending(String orderId, String studentId) async {
    final raw = _box.get(_pendingKey(orderId));
    if (raw is! List) return;
    final ids = raw.map((e) => e.toString()).toList();
    if (!ids.contains(studentId)) return;
    ids.remove(studentId);
    await _box.put(_pendingKey(orderId), ids);
  }
}
