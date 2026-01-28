import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/capture_providers.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = useTextEditingController(text: 'photographer_01');
    final password = useTextEditingController(text: 'secure_password');

    final isLoading = useState(false);
    final online = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(online ? 'Online' : 'Offline', style: Theme.of(context).textTheme.labelLarge),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: username,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading.value
                    ? null
                    : () async {
                        isLoading.value = true;
                        try {
                          final u = username.text.trim();
                          final p = password.text;
                          await ref.read(sessionProvider.notifier).login(username: u, password: p);
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        } finally {
                          isLoading.value = false;
                        }
                      },
                child: Text(isLoading.value ? 'Logging in...' : 'Login'),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Offline-first: after a successful online login, you can re-enter offline with the same credentials.\n'
              'Students are cached locally and uploads sync in chunks of 10.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
