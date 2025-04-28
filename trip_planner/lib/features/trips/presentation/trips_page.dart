import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/adaptive_fab.dart';
import '../data/trip_repository.dart';
import '../model/trip.dart';
import 'trip_card.dart';
import 'new_trip_page.dart';

/// Holds the current search query (Riverpod makes rebuild easy)
final tripSearchProvider = StateProvider<String>((_) => '');

/// Currently selected tag filter; null means “all”.
final tagFilterProvider = StateProvider<String?>((_) => null);

class TripsPage extends ConsumerStatefulWidget {
  const TripsPage({super.key});

  @override
  ConsumerState<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends ConsumerState<TripsPage> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTrips = ref.watch(tripRepoProvider);
    final query = ref.watch(tripSearchProvider);
    final tag = ref.watch(tagFilterProvider);

    // ---------- build list of tags for filter bar ----------
    final allTags =
        <String>{for (final t in allTrips) ...t.tags}.toList()..sort();

    // ---------- apply filters ----------
    List<Trip> visible =
        allTrips.where((t) {
            final matchesQuery =
                query.isEmpty ||
                t.title.toLowerCase().contains(query) ||
                t.origin.toLowerCase().contains(query) ||
                t.destination.toLowerCase().contains(query);

            final matchesTag = tag == null || t.tags.contains(tag);
            return matchesQuery && matchesTag;
          }).toList()
          // optional: sort by start date
          ..sort((a, b) => a.start.compareTo(b.start));

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png', // <-- add to pubspec
          height: 32,
          errorBuilder:
              (_, __, ___) => const Text(
                'Trips',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ---------- search bar ----------
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search trips…',
                suffixIcon:
                    query.isEmpty
                        ? null
                        : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            ref.read(tripSearchProvider.notifier).state = '';
                          },
                        ),
                border: const OutlineInputBorder(),
              ),
              onChanged:
                  (txt) =>
                      ref.read(tripSearchProvider.notifier).state =
                          txt.toLowerCase(),
            ),
            const SizedBox(height: 8),

            if (allTags.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: tag == null,
                      onSelected:
                          (_) =>
                              ref.read(tagFilterProvider.notifier).state = null,
                    ),
                    const SizedBox(width: 4),
                    ...allTags.map(
                      (tg) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: ChoiceChip(
                          label: Text(tg),
                          selected: tag == tg,
                          onSelected:
                              (_) =>
                                  ref.read(tagFilterProvider.notifier).state =
                                      tg,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (allTags.isNotEmpty) const SizedBox(height: 8),

            Expanded(
              child:
                  visible.isEmpty
                      ? const Center(child: Text('No trips found'))
                      : ListView.builder(
                        itemCount: visible.length,
                        itemBuilder: (_, i) => TripCard(trip: visible[i]),
                      ),
            ),
          ],
        ),
      ),

      floatingActionButton: AdaptiveFab(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewTripPage()),
            ),
      ),
    );
  }
}
