import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/baggage_repository.dart';
import '../domain/baggage_item.dart';

class BaggageItemCard extends ConsumerWidget {
  const BaggageItemCard({
    super.key,
    required this.item,
    required this.tripId,
    required this.index,
  });

  final BaggageItem item;
  final String tripId;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      key: ValueKey('${item.name}-$index'),
      elevation: item.checked ? 0 : 2,
      color: item.checked ? cs.surfaceVariant : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(
          value: item.checked,
          onChanged:
              (_) =>
                  ref.read(baggageRepoProvider.notifier).toggle(tripId, index),
        ),
        title: Text(
          item.name,
          style:
              item.checked
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed:
              () =>
                  ref.read(baggageRepoProvider.notifier).remove(tripId, index),
        ),
      ),
    );
  }
}
