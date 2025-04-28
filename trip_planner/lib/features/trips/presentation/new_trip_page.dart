import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import '../data/trip_repository.dart';
import '../domain/trip.dart';

class NewTripPage extends ConsumerStatefulWidget {
  const NewTripPage({super.key});
  @override
  ConsumerState<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends ConsumerState<NewTripPage> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final _titleCtrl = TextEditingController();
  final _originCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  bool _hasReturn = false;
  DateTime? _start, _end;

  /* ---------- TAGS ---------- */
  static const _defaultTags = [
    'Vacation',
    'Business',
    'Work',
    'Conference',
    'Family',
    'Weekend',
  ];
  final _selectedTags = <String>{};

  /* ---------- CITY AUTOCOMPLETE ---------- */
  Future<List<String>> _fetchCities(String pattern) async {
    if (pattern.length < 2) return const [];
    final uri = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$pattern&count=10&language=en',
    );
    try {
      final res = await http.get(uri);
      if (res.statusCode != 200) return const [];
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final results = (json['results'] ?? []) as List<dynamic>;
      return results.map((e) => e['name'] as String).toSet().toList();
    } catch (_) {
      return const [];
    }
  }

  /* ---------- DATE PICKER ---------- */
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
      initialDate: now,
    );
    if (picked != null) {
      setState(() => isStart ? _start = picked : _end = picked);
    }
  }

  /* ---------- SAVE ---------- */
  void _save() {
    if (_formKey.currentState!.validate() && _start != null) {
      final trip = Trip(
        title: _titleCtrl.text.trim(),
        origin: _originCtrl.text.trim(),
        destination: _destCtrl.text.trim(),
        start: _start!,
        end: _hasReturn ? _end : null,
        hasReturn: _hasReturn,
        tags: _selectedTags.toList(),
        notes: _notesCtrl.text,
      );
      ref.read(tripRepoProvider.notifier).addWithReturn(trip);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _originCtrl.dispose();
    _destCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  /* ---------- CITY FIELD BUILDER ---------- */
  Widget _cityField({
    required TextEditingController controller,
    required String label,
  }) {
    final node = FocusNode();
    return TypeAheadField<String>(
      controller: controller,
      focusNode: node,
      suggestionsCallback: _fetchCities,
      itemBuilder: (_, s) => ListTile(title: Text(s)),
      onSelected: (s) => controller.text = s,
      builder:
          (context, _, focusNode) => TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Enter city' : null,
          ),
    );
  }

  /* ---------- BUILD ---------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Trip')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // name
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Trip name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),

              // origin & destination
              _cityField(controller: _originCtrl, label: 'From city'),
              const SizedBox(height: 12),
              _cityField(controller: _destCtrl, label: 'To city'),
              const SizedBox(height: 12),

              // dates
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(isStart: true),
                      child: Text(
                        _start == null
                            ? 'Start date'
                            : _start!.toString().split(' ').first,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _hasReturn ? () => _pickDate(isStart: false) : null,
                      child: Text(
                        _end == null
                            ? 'Return date'
                            : _end!.toString().split(' ').first,
                      ),
                    ),
                  ),
                ],
              ),

              SwitchListTile(
                title: const Text('Has return trip'),
                value: _hasReturn,
                onChanged: (v) => setState(() => _hasReturn = v),
              ),
              const SizedBox(height: 12),

              // ---------- TAG PICKER ----------
              const Text('Tags'),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children:
                    _defaultTags.map((tag) {
                      final selected = _selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: selected,
                        onSelected:
                            (_) => setState(() {
                              selected
                                  ? _selectedTags.remove(tag)
                                  : _selectedTags.add(tag);
                            }),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),

              // notes
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Create trip'),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
