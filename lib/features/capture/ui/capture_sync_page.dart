import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/models.dart';
import '../providers/capture_providers.dart';

class CaptureSyncPage extends ConsumerWidget {
  const CaptureSyncPage({super.key, required this.session});

  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sync')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(online ? Icons.wifi : Icons.wifi_off),
            title: Text(online ? 'Online' : 'Offline'),
            subtitle: const Text('Sync uploads pending capture records.'),
          ),
          const Divider(height: 1),
          for (final orderId in session.orderIds)
            ListTile(
              title: Text('School Code: $orderId'),
              subtitle: const Text('Sync next 10 ready records'),
              trailing: IconButton(
                tooltip: online ? 'Sync now' : 'Offline',
                onPressed: !online
                    ? null
                    : () async {
                        final res = await ref
                            .read(captureSyncRepositoryProvider)
                            .syncNextChunk(
                              orderId: orderId,
                              editedBy: session.userId,
                            );
                        if (!context.mounted) return;
                        if (res == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Nothing to sync (no ready pending records).',
                              ),
                            ),
                          );
                          return;
                        }
                        final failed = res.failedIds.length;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Sync done for $orderId. Failed: $failed',
                            ),
                          ),
                        );
                      },
                icon: const Icon(Icons.cloud_upload_outlined),
              ),
            ),
        ],
      ),
    );
  }
}
