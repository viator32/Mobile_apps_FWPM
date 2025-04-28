import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/trip.dart';

class TripRepository extends StateNotifier<List<Trip>> {
  TripRepository() : super(const []);

  void add(Trip trip) => state = [...state, trip];

  Trip? byId(String id) {
    try {
      return state.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void update(Trip updated) =>
      state = [for (final t in state) (t.id == updated.id) ? updated : t];

  void remove(String id) {
    var next = state.where((t) => t.id != id).toList();

    next =
        next
            .map(
              (t) =>
                  t.returnTripId == id
                      ? Trip(
                        title: t.title,
                        origin: t.origin,
                        destination: t.destination,
                        start: t.start,
                        end: t.end,
                        hasReturn: false,
                        tags: List<String>.from(t.tags),
                        notes: t.notes,
                        ticketUrl: t.ticketUrl,
                        photoUrl: t.photoUrl,
                        id: t.id,
                      )
                      : t,
            )
            .toList();

    state = next;
  }

  void addWithReturn(Trip trip) {
    if (!trip.hasReturn || trip.end == null) {
      add(trip);
      return;
    }

    final forward = trip;

    final back = Trip(
      title: '${trip.title} (Return)',
      origin: trip.destination,
      destination: trip.origin,
      start: trip.end!,
      hasReturn: false,
      tags: List<String>.from(trip.tags),
      notes: trip.notes,
      ticketUrl: trip.ticketUrl,
      photoUrl: trip.photoUrl,
      returnTripId: forward.id,
    );

    final forwardLinked = Trip(
      title: forward.title,
      origin: forward.origin,
      destination: forward.destination,
      start: forward.start,
      end: forward.end,
      hasReturn: true,
      tags: List<String>.from(forward.tags),
      notes: forward.notes,
      ticketUrl: forward.ticketUrl,
      photoUrl: forward.photoUrl,
      returnTripId: back.id,
      id: forward.id, // keep original ID
    );

    state = [...state, forwardLinked, back];
  }
}

final tripRepoProvider = StateNotifierProvider<TripRepository, List<Trip>>(
  (ref) => TripRepository(),
);
