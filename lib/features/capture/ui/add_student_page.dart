import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/capture_providers.dart';

class AddStudentPage extends HookConsumerWidget {
  const AddStudentPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admNo = useTextEditingController();
    final name = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Student (Offline)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: admNo,
              decoration: const InputDecoration(labelText: 'Admission No'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (admNo.text.trim().isEmpty || name.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter adm no and name.')),
                    );
                    return;
                  }

                  await ref.read(captureOrdersRepositoryProvider).addLocalStudent(
                        orderId: orderId,
                        admNo: admNo.text.trim(),
                        name: name.text.trim(),
                      );

                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text('Add to local cache'),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This student is added to the encrypted local cache and will sync after capture, in chunks of 10.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
