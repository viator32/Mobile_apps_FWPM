import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'services/database_service.dart';

import 'features/trips/model/trip.dart';
import 'features/trips/data/trip_repository.dart';

import 'features/baggage/model/baggage_item.dart';
import 'features/baggage/data/baggage_repository.dart';

/// 1️⃣ Low-level DB service:
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

/// 2️⃣ Trip persistence + state:
final tripRepoProvider = StateNotifierProvider<TripRepository, List<Trip>>((
  ref,
) {
  final db = ref.watch(databaseServiceProvider);
  return TripRepository(db);
});

/// 3️⃣ Baggage persistence + state:
final baggageRepoProvider =
    StateNotifierProvider<BaggageRepository, Map<String, List<BaggageItem>>>((
      ref,
    ) {
      final db = ref.watch(databaseServiceProvider);
      return BaggageRepository(db);
    });
