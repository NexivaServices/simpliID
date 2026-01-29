import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/models.dart';
import '../providers/capture_providers.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key, required this.session});

  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders / Schools'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(sessionProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(online ? Icons.wifi : Icons.wifi_off),
            title: Text(online ? 'Online' : 'Offline'),
            subtitle: Text('User ID: ${session.userId}'),
          ),
          const Divider(height: 1),
          for (final orderId in session.orderIds)
            ListTile(
              title: Text('School Code: $orderId'),
              subtitle: const Text(
                'Tap to open students (50/page + infinite scroll)',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/order/$orderId');
              },
            ),
        ],
      ),
    );
  }
}
