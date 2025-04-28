// lib/features/settings/presentation/settings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/theme_provider.dart';

/// Providers for persisted switches
final reminderEnabledProvider = StateNotifierProvider<BoolPref, bool>(
  (ref) => BoolPref('reminderEnabled', defaultValue: true),
);
final defaultTipsProvider = StateNotifierProvider<BoolPref, bool>(
  (ref) => BoolPref('defaultTips', defaultValue: true),
);

class BoolPref extends StateNotifier<bool> {
  final String key;
  final bool defaultValue;
  BoolPref(this.key, {this.defaultValue = false}) : super(false) {
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = p.getBool(key) ?? defaultValue;
  }

  Future<void> toggle() async {
    state = !state;
    final p = await SharedPreferences.getInstance();
    await p.setBool(key, state);
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final reminderOn = ref.watch(reminderEnabledProvider);
    final tipsOn = ref.watch(defaultTipsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Appearance ──
          Text('Appearance', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          DropdownMenu<ThemeMode>(
            label: const Text('Theme Mode'),
            initialSelection: themeMode,
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: ThemeMode.system, label: 'System'),
              DropdownMenuEntry(value: ThemeMode.light, label: 'Light'),
              DropdownMenuEntry(value: ThemeMode.dark, label: 'Dark'),
            ],
            onSelected: (mode) {
              if (mode != null) {
                ref.read(themeProvider.notifier).state = mode;
              }
            },
          ),
          const Divider(height: 32),

          // ── Reminders & Tips ──
          Text('Preferences', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Trip reminders'),
            subtitle: const Text('Notify me before each trip'),
            value: reminderOn,
            onChanged:
                (_) => ref.read(reminderEnabledProvider.notifier).toggle(),
          ),
          SwitchListTile(
            title: const Text('Default packing tips'),
            subtitle: const Text('Show helpful packing suggestions'),
            value: tipsOn,
            onChanged: (_) => ref.read(defaultTipsProvider.notifier).toggle(),
          ),
          const Divider(height: 32),

          // ── About ──
          Text('About', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (ctx, snap) {
              final info = snap.data;
              final version =
                  info != null
                      ? '${info.version}+${info.buildNumber}'
                      : 'Loading...';
              return ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Version'),
                subtitle: Text(version),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Contact Us'),
            onTap:
                () => launchUrl(
                  Uri(scheme: 'mailto', path: 'support@example.com'),
                ),
          ),
        ],
      ),
    );
  }
}
