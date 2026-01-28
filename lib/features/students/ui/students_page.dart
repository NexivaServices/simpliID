import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/student_providers.dart';
import 'upsert_student_page.dart';

class StudentsPage extends ConsumerWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UpsertStudentPage()));
        },
        child: const Icon(Icons.add),
      ),
      body: students.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No students yet. Tap + to add one.'));
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final student = items[index];
              return ListTile(
                title: Text(student.fullName),
                subtitle: Text(student.email ?? student.phone ?? ''),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => UpsertStudentPage(studentId: student.id)),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load students: $e')),
      ),
    );
  }
}
