import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/student_repository.dart';
import '../models/models.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository.fromHive();
});

final studentsProvider = StreamProvider<List<Student>>((ref) {
  final repo = ref.watch(studentRepositoryProvider);
  return repo.watchAll();
});

final studentIdFactoryProvider = Provider<Uuid>((ref) => const Uuid());
