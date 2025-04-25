import 'package:flutter/material.dart';

class AdaptiveFab extends StatelessWidget {
  const AdaptiveFab({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return isWide
        ? FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('New Trip'),
          onPressed: onPressed,
        )
        : FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: onPressed,
        );
  }
}
