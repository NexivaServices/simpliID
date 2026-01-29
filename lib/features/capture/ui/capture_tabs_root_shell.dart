import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/models.dart';

class CaptureTabsRootShell extends HookConsumerWidget {
  const CaptureTabsRootShell({
    super.key,
    required this.navigationShell,
    required this.session,
  });

  final StatefulNavigationShell navigationShell;
  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;
    
    // Get current route location to determine depth
    final location = GoRouterState.of(context).matchedLocation;
    final pathSegments = location.split('/').where((s) => s.isNotEmpty).length;
    
    // Show navbar only on student listing page (depth 2 in Home tab: /order/:id)
    // or on root of other tabs
    final showNavBar = currentIndex == 0 ? pathSegments == 2 : pathSegments <= 1;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: showNavBar
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
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
    );
  }
}
