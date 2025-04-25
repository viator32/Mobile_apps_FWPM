import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/adaptive_fab.dart';
import '../data/trip_repository.dart';
import 'trip_card.dart';

class TripsPage extends ConsumerWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripRepoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trips')),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (_, i) => TripCard(trip: trips[i]),
      ),
      floatingActionButton: AdaptiveFab(
        // OLD: Navigator.pushNamed(context, '/new')
        onPressed: () => context.push('/new'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (i) {
          if (i == 1) context.go('/settings');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.card_travel), label: 'Trips'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
