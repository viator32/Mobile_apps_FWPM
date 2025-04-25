import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/trips/presentation/trips_page.dart';
import '../features/settings/presentation/settings_page.dart';

final currentTabProvider = StateProvider<int>((_) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(currentTabProvider);

    return Scaffold(
      body: IndexedStack(
        index: tab,
        children: const [
          TripsPage(), // kept alive even when not visible
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected:
            (i) => ref.read(currentTabProvider.notifier).state = i,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.card_travel), label: 'Trips'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
