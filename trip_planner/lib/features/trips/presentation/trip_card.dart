import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/trip.dart';
import 'trip_details_page.dart'; // make sure this import path is correct

class TripCard extends StatelessWidget {
  const TripCard({required this.trip, super.key});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysToGo = trip.start.difference(now).inDays;
    final dateText =
        (daysToGo >= 0 && daysToGo < 14)
            ? 'Trip in $daysToGo day${daysToGo == 1 ? '' : 's'}'
            : DateFormat.yMMMd().format(trip.start);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.indigo,
          child: Icon(Icons.card_travel, color: Colors.white),
        ),

        title: Text(
          trip.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${trip.origin} → ${trip.destination}'),
            Text(dateText, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children:
                  trip.tags
                      .map(
                        (tag) =>
                            Chip(label: Text(tag), padding: EdgeInsets.zero),
                      )
                      .toList(),
            ),
          ],
        ),

        trailing: const Icon(Icons.chevron_right),

        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TripDetailsPage(tripId: trip.id),
              ),
            ),
      ),
    );
  }
}
