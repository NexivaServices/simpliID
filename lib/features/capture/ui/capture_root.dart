import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/capture_providers.dart';
import 'login_page.dart';
import 'capture_tabs_root.dart';

class CaptureRoot extends ConsumerWidget {
  const CaptureRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    if (session == null) {
      return const LoginPage();
    }

    return CaptureTabsRoot(session: session);
  }
}
