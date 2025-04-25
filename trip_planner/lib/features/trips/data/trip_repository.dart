import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/trip.dart';

class TripRepository extends StateNotifier<List<Trip>> {
  TripRepository() : super(const []);

  void add(Trip trip) => state = [...state, trip];
  Trip? byId(String id) => state.firstWhere((t) => t.id == id);
}

final tripRepoProvider = StateNotifierProvider<TripRepository, List<Trip>>(
  (_) => TripRepository(),
);
