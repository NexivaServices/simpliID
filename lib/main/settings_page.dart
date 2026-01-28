import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../core/app_info/app_info_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pkg = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('About'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Open-source licenses'),
                description: const Text('Third-party notices and licenses'),
                onPressed: (context) {
                  showLicensePage(
                    context: context,
                    applicationName: 'simpliid',
                  );
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App version'),
                description: pkg.when(
                  data: (p) => Text('${p.version} (${p.buildNumber})'),
                  loading: () => const Text('...'),
                  error: (e, _) => Text('Error: $e'),
                ),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Share'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share app'),
                description: const Text('Send the app link to others'),
                onPressed: (context) {
                  SharePlus.instance.share(ShareParams(text: 'Check out simpliid!'));
                },
              ),
            ],
          ),
        ],
      ) ,
    );
  }
}
