import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../luggage/presentation/baggage_page.dart';
import '../data/trip_repository.dart';

class TripDetailsPage extends ConsumerWidget {
  const TripDetailsPage({required this.tripId, super.key});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(tripRepoProvider).firstWhere((t) => t.id == tripId);
    final df = DateFormat.yMMMd();

    Future<void> removeTrip() async {
      ref.read(tripRepoProvider.notifier).remove(trip.id);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: push NewTripPage pre-filled
            },
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: removeTrip),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${trip.origin}  ➜  ${trip.destination}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            df.format(trip.start) +
                (trip.end != null ? '  –  ${df.format(trip.end!)}' : ''),
          ),
          const SizedBox(height: 12),

          if (trip.photoUrl != null || trip.ticketUrl != null) ...[
            if (trip.photoUrl != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(trip.photoUrl!, fit: BoxFit.cover),
                ),
              ),
            if (trip.ticketUrl != null)
              ListTile(
                leading: const Icon(Icons.link),
                title: Text(trip.ticketUrl!),
                onTap: () => launchUrl(Uri.parse(trip.ticketUrl!)),
              ),
            const SizedBox(height: 16),
          ],

          if (trip.tags.isNotEmpty) ...[
            Wrap(
              spacing: 4,
              children: trip.tags.map((t) => Chip(label: Text(t))).toList(),
            ),
            const SizedBox(height: 16),
          ],

          Card(
            child: ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Baggage'),
              trailing: const Icon(Icons.chevron_right),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BaggagePage(tripId: trip.id),
                    ),
                  ),
            ),
          ),

          if (trip.returnTripId != null) ...[
            const SizedBox(height: 8),
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: ListTile(
                leading: const Icon(Icons.undo),
                title: const Text('Return Trip'),
                trailing: const Icon(Icons.chevron_right),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => TripDetailsPage(tripId: trip.returnTripId!),
                      ),
                    ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          const Text('Notes'),
          const SizedBox(height: 4),
          Text(trip.notes.isEmpty ? '—' : trip.notes),
        ],
      ),
    );
  }
}
