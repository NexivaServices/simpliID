import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/models.dart';
import 'capture_sync_page.dart';
import 'orders_page.dart';
import '../../../main/settings_page.dart';

class CaptureTabsRoot extends ConsumerStatefulWidget {
  const CaptureTabsRoot({super.key, required this.session});

  final Session session;

  @override
  ConsumerState<CaptureTabsRoot> createState() => _CaptureTabsRootState();
}

class _CaptureTabsRootState extends ConsumerState<CaptureTabsRoot> {
  int _index = 0;

  final _homeNavKey = GlobalKey<NavigatorState>();
  final _syncNavKey = GlobalKey<NavigatorState>();
  final _settingsNavKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get _currentNavKey {
    return switch (_index) {
      0 => _homeNavKey,
      1 => _syncNavKey,
      _ => _settingsNavKey,
    };
  }

  Future<bool> _onWillPop() async {
    final navigator = _currentNavKey.currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return false;
    }

    if (_index != 0) {
      setState(() => _index = 0);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final navigator = _currentNavKey.currentState;
    final allowPopRoute = _index == 0 && !(navigator?.canPop() ?? false);
    
    // Show navbar only when on the root route (first screen) of each tab
    final showNavBar = !(navigator?.canPop() ?? false);

    return PopScope(
      canPop: allowPopRoute,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        // ignore: discarded_futures
        _onWillPop();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            Navigator(
              key: _homeNavKey,
              onGenerateRoute: (settings) {
                // Rebuild when navigation happens
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() {});
                });
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => OrdersPage(session: widget.session),
                );
              },
              onDidRemovePage: (_) => setState(() {}),
            ),
            Navigator(
              key: _syncNavKey,
              onGenerateRoute: (settings) {
                // Rebuild when navigation happens
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() {});
                });
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => CaptureSyncPage(session: widget.session),
                );
              },
              onDidRemovePage: (_) => setState(() {}),
            ),
            Navigator(
              key: _settingsNavKey,
              onGenerateRoute: (settings) {
                // Rebuild when navigation happens
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() {});
                });
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const SettingsPage(),
                );
              },
              onDidRemovePage: (_) => setState(() {}),
            ),
          ],
        ),
        bottomNavigationBar: showNavBar
            ? BottomNavigationBar(
                currentIndex: _index,
                onTap: (next) {
                  if (next == _index) {
                    _currentNavKey.currentState?.popUntil((r) => r.isFirst);
                    return;
                  }
                        setState(() => _index = next);
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
