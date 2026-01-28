import 'package:hive/hive.dart';

import '../../../core/storage/hive_bootstrap.dart';
import '../models/models.dart';

class StudentRepository {
  StudentRepository(this._box);

  final Box _box;

  static const _prefix = 'student:';

  List<Student> getAll() {
    final students = <Student>[];

    for (final key in _box.keys) {
      if (key is! String) continue;
      if (!key.startsWith(_prefix)) continue;

      final raw = _box.get(key);
      if (raw is Map) {
        students.add(Student.fromJson(Map<String, dynamic>.from(raw)));
      }
    }

    students.sort(
      (a, b) =>
          (a.fullName).toLowerCase().compareTo((b.fullName).toLowerCase()),
    );
    return students;
  }

  Stream<List<Student>> watchAll() async* {
    yield getAll();
    await for (final _ in _box.watch()) {
      yield getAll();
    }
  }

  Future<void> upsert(Student student) async {
    await _box.put('$_prefix${student.id}', student.toJson());
  }

  Future<void> delete(String id) async {
    await _box.delete('$_prefix$id');
  }

  static StudentRepository fromHive() {
    final box = Hive.box(HiveBoxes.secure);
    return StudentRepository(box);
  }
}
