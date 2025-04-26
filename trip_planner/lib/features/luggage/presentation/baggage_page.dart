import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/baggage_repository.dart';

class BaggagePage extends ConsumerWidget {
  const BaggagePage({required this.tripId, super.key});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(baggageRepoProvider)[tripId] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Packing list')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder:
            (_, i) => CheckboxListTile(
              title: Text(items[i].name),
              value: items[i].checked,
              onChanged:
                  (_) =>
                      ref.read(baggageRepoProvider.notifier).toggle(tripId, i),
              secondary: IconButton(
                icon: const Icon(Icons.delete),
                onPressed:
                    () => ref
                        .read(baggageRepoProvider.notifier)
                        .remove(tripId, i),
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
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
                  TextButton(
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
        },
      ),
    );
  }
}
