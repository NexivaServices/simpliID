import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/models.dart';
import 'capture_sync_page.dart';
import 'orders_page.dart';
import '../../../main/settings_page.dart';

class CaptureTabsRoot extends HookConsumerWidget {
  const CaptureTabsRoot({super.key, required this.session});

  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = useState(0);
    final homeNavDepth = useState(0);

    final homeNavKey = useMemoized(() => GlobalKey<NavigatorState>());
    final syncNavKey = useMemoized(() => GlobalKey<NavigatorState>());
    final settingsNavKey = useMemoized(() => GlobalKey<NavigatorState>());

    GlobalKey<NavigatorState> getCurrentNavKey() {
      return switch (index.value) {
        0 => homeNavKey,
        1 => syncNavKey,
        _ => settingsNavKey,
      };
    }

    Future<bool> onWillPop() async {
      final navigator = getCurrentNavKey().currentState;
      if (navigator != null && navigator.canPop()) {
        navigator.pop();
        return false;
      }

      if (index.value != 0) {
        index.value = 0;
        return false;
      }

      return true;
    }
    final navigator = getCurrentNavKey().currentState;
    final allowPopRoute = index.value == 0 && !(navigator?.canPop() ?? false);

    final canPop = navigator?.canPop() ?? false;
    final showNavBar = index.value == 0 ? homeNavDepth.value == 1 : !canPop;

    return PopScope(
      canPop: allowPopRoute,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        onWillPop();
      },
      child: Scaffold(
        body: IndexedStack(
          index: index.value,
          children: [
            Navigator(
              key: homeNavKey,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => OrdersPage(session: session),
                );
              },
              observers: [
                _HomeNavigatorObserver((depth) {
                  if (context.mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      homeNavDepth.value = depth;
                    });
                  }
                }),
              ],
            ),
            Navigator(
              key: syncNavKey,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => CaptureSyncPage(session: session),
                );
              },
            ),
            Navigator(
              key: settingsNavKey,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const SettingsPage(),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: showNavBar
            ? BottomNavigationBar(
                currentIndex: index.value,
                onTap: (next) {
                  if (next == index.value) {
                    getCurrentNavKey().currentState?.popUntil((r) => r.isFirst);
                    return;
                  }
                  index.value = next;
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.sync_outlined),
                    activeIcon: Icon(Icons.sync),
                    label: 'Sync',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    activeIcon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

class _HomeNavigatorObserver extends NavigatorObserver {
  _HomeNavigatorObserver(this.onDepthChange);

  final void Function(int depth) onDepthChange;
  int _depth = 0;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _depth++;
    onDepthChange(_depth);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _depth = _depth > 0 ? _depth - 1 : 0;
    onDepthChange(_depth);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _depth = _depth > 0 ? _depth - 1 : 0;
    onDepthChange(_depth);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    onDepthChange(_depth);
  }
}
