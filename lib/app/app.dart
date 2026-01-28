import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/battery/battery_providers.dart';
import '../core/connectivity/connectivity_providers.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityResultsProvider);
    final batteryLevel = ref.watch(batteryLevelProvider);

    return MaterialApp(
      title: 'simpliid',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: Scaffold(
        appBar: AppBar(title: const Text('simpliid')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              connectivity.when(
                data: (results) => Text('Connectivity: ${results.join(', ')}'),
                loading: () => const Text('Connectivity: ...'),
                error: (e, _) => Text('Connectivity: error ($e)'),
              ),
              const SizedBox(height: 8),
              batteryLevel.when(
                data: (level) => Text('Battery level: $level%'),
                loading: () => const Text('Battery level: ...'),
                error: (e, _) => Text('Battery level: error ($e)'),
              ),
              const SizedBox(height: 16),
              const Text('Project bootstrapped with Riverpod + Hooks + Dio + Hive + Freezed.'),
            ],
          ),
        ),
      ),
    );
  }
}
