import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/baggage_repository.dart';
import 'baggage_item_card.dart';

class BaggagePage extends ConsumerStatefulWidget {
  const BaggagePage({required this.tripId, super.key});
  final String tripId;

  //“advisor” & default list:
  static const _defaultItems = [
    'Passport',
    'Tickets',
    'Toothbrush',
    'Phone charger',
    'Clothes',
    'Socks',
    'Underwear',
    'Medications',
    'Sunglasses',
    'Wallet',
  ];

  @override
  ConsumerState<BaggagePage> createState() => _BaggagePageState();
}

class _BaggagePageState extends ConsumerState<BaggagePage> {
  @override
  void initState() {
    super.initState();
    // Load persisted items on startup
    ref.read(baggageRepoProvider.notifier).forTrip(widget.tripId);
  }

  Future<void> _addItem() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('New item'),
          content: TextField(controller: ctrl, autofocus: true),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    if (name != null && name.isNotEmpty) {
      await ref.read(baggageRepoProvider.notifier).add(widget.tripId, name);
    }
  }

  void _showAdvisor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomCtx) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Packing Advisor',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: BaggagePage._defaultItems.length,
                      itemBuilder: (ctx, i) {
                        final item = BaggagePage._defaultItems[i];
                        return ListTile(
                          title: Text(item),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.pop(bottomCtx);
                              ref
                                  .read(baggageRepoProvider.notifier)
                                  .add(widget.tripId, item);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    icon: const Icon(Icons.playlist_add_check),
                    label: const Text('Add All Items'),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: const Text('Import all default items?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.pop(ctx, false),
                                ),
                                TextButton(
                                  child: const Text('Import'),
                                  onPressed: () => Navigator.pop(ctx, true),
                                ),
                              ],
                            ),
                      );
                      if (ok == true) {
                        Navigator.pop(bottomCtx);
                        final notifier = ref.read(baggageRepoProvider.notifier);
                        for (final item in BaggagePage._defaultItems) {
                          await notifier.add(widget.tripId, item);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(baggageRepoProvider)[widget.tripId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Packing list'),
        actions: [
          Tooltip(
            message: 'Packing Advisor',
            child: IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: _showAdvisor,
            ),
          ),
        ],
      ),
      body:
          items.isEmpty
              ? const Center(
                child: Text(
                  'Nothing packed yet – tap + to add your first item.',
                  textAlign: TextAlign.center,
                ),
              )
              : ReorderableListView.builder(
                padding: const EdgeInsets.only(bottom: 88, top: 8),
                itemCount: items.length,
                onReorder: (oldIdx, newIdx) {
                  ref
                      .read(baggageRepoProvider.notifier)
                      .reorder(widget.tripId, oldIdx, newIdx);
                },
                itemBuilder:
                    (_, i) => BaggageItemCard(
                      key: ValueKey(items[i].id),
                      item: items[i],
                      tripId: widget.tripId,
                      index: i,
                    ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
