import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';

class App extends HookConsumerWidget {
  const App({super.key, this.enableUpgradeAlert = true});

  final bool enableUpgradeAlert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    
    final app = MaterialApp.router(
      title: 'simpliid',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );

    if (!enableUpgradeAlert) {
      return app;
    }

    return UpgradeAlert(child: app);
  }
}
