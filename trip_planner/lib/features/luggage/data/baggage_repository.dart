import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/baggage_item.dart';

class BaggageRepository extends StateNotifier<Map<String, List<BaggageItem>>> {
  BaggageRepository() : super({});

  List<BaggageItem> forTrip(String id) => state[id] ?? [];

  void add(String tripId, String item) {
    final list = [...forTrip(tripId), BaggageItem(name: item)];
    state = {...state, tripId: list};
  }

  void toggle(String tripId, int index) {
    final list = forTrip(tripId);
    list[index].checked = !list[index].checked;
    state = {
      ...state,
      tripId: [...list],
    };
  }

  void remove(String tripId, int index) {
    final list = forTrip(tripId)..removeAt(index);
    state = {...state, tripId: list};
  }
}

final baggageRepoProvider =
    StateNotifierProvider<BaggageRepository, Map<String, List<BaggageItem>>>(
      (_) => BaggageRepository(),
    );
