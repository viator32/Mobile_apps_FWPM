import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/adaptive_fab.dart';
import '../data/trip_repository.dart';
import '../domain/trip.dart';
import 'trip_card.dart';
import 'new_trip_page.dart';

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
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewTripPage()),
            ),
      ),
    );
  }
}
