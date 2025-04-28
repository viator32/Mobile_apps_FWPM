import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/baggage_repository.dart';
import 'baggage_item_card.dart';

class BaggagePage extends ConsumerWidget {
  const BaggagePage({required this.tripId, super.key});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(baggageRepoProvider)[tripId] ?? [];

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
        ref.read(baggageRepoProvider.notifier).add(tripId, name);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Packing list')),
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
                      .reorder(tripId, oldIdx, newIdx);
                },
                itemBuilder:
                    (_, i) => BaggageItemCard(
                      key: ValueKey('${items[i].name}-$i'),
                      item: items[i],
                      tripId: tripId,
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
