import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 👈 add
import '../domain/trip.dart';

class TripCard extends StatelessWidget {
  const TripCard({required this.trip, super.key});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(trip.title),
        subtitle: Wrap(
          spacing: 4,
          children:
              trip.tags
                  .map(
                    (tag) => Chip(label: Text(tag), padding: EdgeInsets.zero),
                  )
                  .toList(),
        ),
        trailing: const Icon(Icons.chevron_right),
        // OLD: Navigator.pushNamed(context, '/luggage/${trip.id}')
        onTap: () => context.push('/luggage/${trip.id}'), // ✅
      ),
    );
  }
}
