// lib/repos/trip_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/trip.dart';
import '../../../services/database_service.dart';
import '../../../providers.dart';

class TripRepository extends StateNotifier<List<Trip>> {
  final DatabaseService _db;

  TripRepository(this._db) : super([]) {
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    final rows = await _db.getAllTrips();
    state =
        rows.map((r) => Trip.fromMap(Map<String, dynamic>.from(r))).toList();
  }

  Future<void> add(Trip trip) async {
    await _db.insertTrip(trip.toMap());
    state = [...state, trip];
  }

  Future<void> update(Trip updated) async {
    await _db.updateTrip(updated.toMap());
    state = state.map((t) => t.id == updated.id ? updated : t).toList();
  }

  Future<void> remove(String id) async {
    // 1) delete the trip & its baggage
    await _db.deleteTrip(id);

    // 2) fix any trips that pointed at it as a return
    final newState = <Trip>[];
    for (final t in state) {
      if (t.id == id) continue;
      if (t.returnTripId == id) {
        final fixed = t.copyWith(hasReturn: false, returnTripId: null);
        await _db.updateTrip(fixed.toMap());
        newState.add(fixed);
      } else {
        newState.add(t);
      }
    }
    state = newState;
  }

  Future<void> addWithReturn(Trip trip) async {
    if (!trip.hasReturn || trip.end == null) {
      await add(trip);
      return;
    }

    final forward = trip;

    final back = Trip(
      title: '${forward.title} (Return)',
      origin: forward.destination,
      destination: forward.origin,
      start: forward.end!,
      hasReturn: false,
      tags: List.from(forward.tags),
      notes: forward.notes,
      ticketUrl: forward.ticketUrl,
      photoUrl: forward.photoUrl,
      returnTripId: forward.id,
      attachmentPaths: List.from(forward.attachmentPaths),
    );

    final forwardLinked = forward.copyWith(
      hasReturn: true,
      returnTripId: back.id,
    );

    await _db.insertTrip(forwardLinked.toMap());
    await _db.insertTrip(back.toMap());
    state = [...state, forwardLinked, back];
  }

  Future<void> togglePin(String id) async {
    final t = state.firstWhere((t) => t.id == id);
    final updated = t.copyWith(pinned: !t.pinned);
    await _db.updateTrip(updated.toMap());
    state = state.map((t) => t.id == id ? updated : t).toList();
  }
}

final tripRepoProvider = StateNotifierProvider<TripRepository, List<Trip>>((
  ref,
) {
  final db = ref.watch(databaseServiceProvider);
  return TripRepository(db);
});
