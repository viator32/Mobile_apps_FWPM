import 'package:flutter/material.dart';

class LuggagePage extends StatelessWidget {
  const LuggagePage({required this.tripId, super.key});
  final String tripId;

  @override
  Widget build(BuildContext context) {
    // In a real app fetch Trip by ID, show checklist.
    return Scaffold(
      appBar: AppBar(title: const Text('Luggage')),
      body: const Center(child: Text('Packing list goes here')),
    );
  }
}
