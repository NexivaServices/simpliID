import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import '../features/capture/ui/capture_root.dart';

class App extends HookConsumerWidget {
  const App({super.key, this.enableUpgradeAlert = true});

  final bool enableUpgradeAlert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = MaterialApp(
      title: 'simpliid',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: const CaptureRoot(),
    );

    if (!enableUpgradeAlert) {
      return app;
    }

    return UpgradeAlert(child: app);
  }
}
