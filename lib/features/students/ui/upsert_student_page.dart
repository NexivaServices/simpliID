import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/models.dart';
import '../providers/student_providers.dart';

class UpsertStudentPage extends HookConsumerWidget {
  const UpsertStudentPage({super.key, this.studentId});

  final String? studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(studentRepositoryProvider);
    final idFactory = ref.watch(studentIdFactoryProvider);

    final existing = ref
        .watch(studentsProvider)
        .asData
        ?.value
        .firstWhereOrNull((s) => s.id == studentId);

    final fullNameCtrl = useTextEditingController(
      text: existing?.fullName ?? '',
    );
    final emailCtrl = useTextEditingController(text: existing?.email ?? '');
    final phoneCtrl = useTextEditingController(text: existing?.phone ?? '');

    Future<void> save() async {
      final name = fullNameCtrl.text.trim();
      if (name.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Full name is required')));
        return;
      }

      final now = DateTime.now();
      final student = Student(
        id: existing?.id ?? idFactory.v4(),
        fullName: name,
        email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );

      await repo.upsert(student);
      if (context.mounted) Navigator.of(context).pop();
    }

    Future<void> remove() async {
      final id = existing?.id;
      if (id == null) return;

      await repo.delete(id);
      if (context.mounted) Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(existing == null ? 'Add student' : 'Edit student'),
        actions: [
          if (existing != null)
            IconButton(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete student?'),
                    content: const Text('This cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (ok == true) {
                  await remove();
                }
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: fullNameCtrl,
            decoration: const InputDecoration(labelText: 'Full name'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(labelText: 'Email (optional)'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneCtrl,
            decoration: const InputDecoration(labelText: 'Phone (optional)'),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: save, child: const Text('Save')),
        ],
      ),
    );
  }
}

extension _FirstWhereOrNullX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final item in this) {
      if (test(item)) return item;
    }
    return null;
  }
}
