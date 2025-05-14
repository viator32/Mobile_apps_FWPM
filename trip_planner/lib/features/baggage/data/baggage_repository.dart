import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/database_service.dart';
import '../../../providers.dart';
import '../model/baggage_item.dart';

class BaggageRepository extends StateNotifier<Map<String, List<BaggageItem>>> {
  final DatabaseService _db;

  BaggageRepository(this._db) : super({});

  Future<void> _loadForTrip(String tripId) async {
    final rows = await _db.getBaggageForTrip(tripId);
    final items =
        rows
            .map((r) => BaggageItem.fromMap(Map<String, dynamic>.from(r)))
            .toList();
    state = {...state, tripId: items};
  }

  /// Returns the in-memory list if loaded, otherwise fetches from the DB.
  Future<List<BaggageItem>> forTrip(String tripId) async {
    if (!state.containsKey(tripId)) {
      await _loadForTrip(tripId);
    }
    return state[tripId]!;
  }

  Future<void> add(String tripId, String name) async {
    final current = await forTrip(tripId);
    final pos = current.length;
    await _db.insertBaggage({
      'tripId': tripId,
      'name': name,
      'checked': 0,
      'position': pos,
    });
    await _loadForTrip(tripId);
  }

  Future<void> toggle(String tripId, int index) async {
    final list = await forTrip(tripId);
    final item = list[index];
    item.checked = !item.checked;
    await _db.updateBaggage(item.id!, item.toMap());
    state = {
      ...state,
      tripId: [...list],
    };
  }

  Future<void> remove(String tripId, int index) async {
    final list = await forTrip(tripId);
    final removeId = list[index].id!;
    await _db.deleteBaggage(removeId);

    list.removeAt(index);
    // re-assign positions
    for (var i = 0; i < list.length; i++) {
      list[i].position = i;
      await _db.updateBaggage(list[i].id!, list[i].toMap());
    }

    state = {
      ...state,
      tripId: [...list],
    };
  }

  Future<void> reorder(String tripId, int oldIndex, int newIndex) async {
    final list = [...await forTrip(tripId)];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    for (var i = 0; i < list.length; i++) {
      list[i].position = i;
      await _db.updateBaggage(list[i].id!, list[i].toMap());
    }

    state = {...state, tripId: list};
  }
}

final baggageRepoProvider =
    StateNotifierProvider<BaggageRepository, Map<String, List<BaggageItem>>>((
      ref,
    ) {
      final db = ref.watch(databaseServiceProvider);
      return BaggageRepository(db);
    });
