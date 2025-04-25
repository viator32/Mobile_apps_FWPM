import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final brightness = MediaQuery.platformBrightnessOf(context);

    // true if the UI is currently dark, either by explicit choice or by system
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: isDark,
            // one-tap toggle between light & dark (we ignore `system`)
            onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
          ),
          const ListTile(
            title: Text('Imprint'),
            subtitle: Text('Your Name · your@email.com'),
          ),
        ],
      ),

      // ---- bottom navigation identical to Trips page ----
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (i) {
          if (i == 0) context.go('/'); // back to Trips
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.card_travel), label: 'Trips'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
