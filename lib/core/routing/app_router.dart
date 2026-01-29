import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/capture/providers/capture_providers.dart';
import '../../features/capture/ui/add_student_page.dart';
import '../../features/capture/ui/capture_photo_flow.dart';
import '../../features/capture/ui/capture_sync_page.dart';
import '../../features/capture/ui/capture_tabs_root_shell.dart';
import '../../features/capture/ui/login_page.dart';
import '../../features/capture/ui/orders_page.dart';
import '../../features/capture/ui/order_students_page.dart';
import '../../main/settings_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>();
final syncNavigatorKey = GlobalKey<NavigatorState>();
final settingsNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: session == null ? '/login' : '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = session != null;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return CaptureTabsRootShell(
            navigationShell: navigationShell,
            session: session!,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => OrdersPage(session: session!),
                routes: [
                  GoRoute(
                    path: 'order/:orderId',
                    name: 'orderStudents',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId']!;
                      return OrderStudentsPage(orderId: orderId);
                    },
                    routes: [
                      GoRoute(
                        path: 'student/:studentId/capture',
                        name: 'capturePhoto',
                        builder: (context, state) {
                          final orderId = state.pathParameters['orderId']!;
                          final studentId = state.pathParameters['studentId']!;
                          final extra = state.extra as Map<String, dynamic>;
                          return CapturePhotoFlowPage(
                            orderId: orderId,
                            studentId: studentId,
                            studentName: extra['studentName'] as String,
                            studentAdmNo: extra['studentAdmNo'] as String,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'add-student',
                        name: 'addStudent',
                        builder: (context, state) {
                          final orderId = state.pathParameters['orderId']!;
                          return AddStudentPage(orderId: orderId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: syncNavigatorKey,
            routes: [
              GoRoute(
                path: '/sync',
                name: 'sync',
                builder: (context, state) => CaptureSyncPage(session: session!),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: settingsNavigatorKey,
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
