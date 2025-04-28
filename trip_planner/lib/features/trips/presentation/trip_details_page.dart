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
    final diff = trip.start.difference(DateTime.now()).inDays;

    Future<void> removeTrip() async {
      ref.read(tripRepoProvider.notifier).remove(trip.id);
      Navigator.pop(context);
    }

    ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              /* TODO */
            },
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: removeTrip),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /* --- Route & Date --- */
          ListTile(
            leading: CircleAvatar(
              backgroundColor: cs.primaryContainer,
              child: const Icon(Icons.route, color: Colors.white),
            ),
            title: Text(
              '${trip.origin} → ${trip.destination}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              diff >= 0 && diff < 14
                  ? 'Trip in $diff day${diff == 1 ? '' : 's'}'
                  : df.format(trip.start) +
                      (trip.end != null ? '  –  ${df.format(trip.end!)}' : ''),
            ),
          ),
          const SizedBox(height: 12),

          /* --- Hero photo / ticket link --- */
          if (trip.photoUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(trip.photoUrl!, fit: BoxFit.cover),
            ),
          if (trip.ticketUrl != null)
            ListTile(
              leading: const Icon(Icons.airplane_ticket),
              title: const Text('Open tickets'),
              subtitle: Text(trip.ticketUrl!),
              onTap: () => launchUrl(Uri.parse(trip.ticketUrl!)),
            ),
          if (trip.photoUrl != null || trip.ticketUrl != null)
            const SizedBox(height: 16),

          /* --- Tags --- */
          if (trip.tags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              children:
                  trip.tags
                      .map(
                        (t) => Chip(
                          label: Text(t),
                          backgroundColor: cs.secondaryContainer,
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 16),
          ],

          /* --- Action cards --- */
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Open baggage checklist'),
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
              color: cs.tertiaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.undo),
                title: const Text('View return trip'),
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

          /* --- Notes --- */
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(trip.notes.isEmpty ? '—' : trip.notes),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
