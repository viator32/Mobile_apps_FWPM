import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers.dart';
import '../../baggage/presentation/baggage_page.dart';
import '../model/trip.dart';

class TripDetailsPage extends ConsumerStatefulWidget {
  const TripDetailsPage({required this.tripId, super.key});
  final String tripId;

  @override
  ConsumerState<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends ConsumerState<TripDetailsPage> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _originCtrl;
  late TextEditingController _destCtrl;
  late TextEditingController _notesCtrl;
  bool _hasReturn = false;
  DateTime? _start, _end;
  Set<String> _selectedTags = {};

  static const _allTags = [
    'Vacation',
    'Business',
    'Work',
    'Conference',
    'Family',
    'Weekend',
  ];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _originCtrl = TextEditingController();
    _destCtrl = TextEditingController();
    _notesCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _originCtrl.dispose();
    _destCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _startEdit(Trip trip) {
    _titleCtrl.text = trip.title;
    _originCtrl.text = trip.origin;
    _destCtrl.text = trip.destination;
    _notesCtrl.text = trip.notes;
    _hasReturn = trip.hasReturn;
    _start = trip.start;
    _end = trip.end;
    _selectedTags = trip.tags.toSet();
    setState(() => _isEditing = true);
  }

  Future<void> _saveEdit(Trip trip) async {
    if (!_formKey.currentState!.validate() || _start == null) return;

    final updated = trip.copyWith(
      title: _titleCtrl.text.trim(),
      origin: _originCtrl.text.trim(),
      destination: _destCtrl.text.trim(),
      start: _start!,
      end: _hasReturn ? _end : null,
      hasReturn: _hasReturn,
      tags: _selectedTags.toList(),
      notes: _notesCtrl.text.trim(),
    );

    await ref.read(tripRepoProvider.notifier).update(updated);
    setState(() => _isEditing = false);
  }

  Future<void> _confirmDelete(Trip trip) async {
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Trip?'),
            content: const Text(
              'Are you sure you want to delete this trip forever?',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(ctx, false),
              ),
              TextButton(
                child: Text(
                  'Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onPressed: () => Navigator.pop(ctx, true),
              ),
            ],
          ),
    );
    if (ok == true) {
      ref.read(tripRepoProvider.notifier).remove(trip.id);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
      initialDate: isStart ? (_start ?? now) : (_end ?? now),
    );
    if (picked != null) {
      setState(() {
        if (isStart)
          _start = picked;
        else
          _end = picked;
      });
    }
  }

  Future<void> _addAttachment(Trip trip) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      final pathOrName = file.path ?? file.name;
      final updated = [...trip.attachmentPaths, pathOrName];
      ref
          .read(tripRepoProvider.notifier)
          .update(trip.copyWith(attachmentPaths: updated));
    }
  }

  Future<void> _openAttachment(String path) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot open local files on Web.')),
      );
    } else {
      await OpenFile.open(path);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref
        .watch(tripRepoProvider)
        .firstWhere((t) => t.id == widget.tripId);
    final cs = Theme.of(context).colorScheme;
    final df = DateFormat.yMMMd();
    final daysUntil = trip.start.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.title, overflow: TextOverflow.ellipsis),
        actions: [
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _saveEdit(trip),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _isEditing = false),
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _startEdit(trip),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(trip),
            ),
          ],
        ],
      ),
      body:
          _isEditing
              ? Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Title
                      TextFormField(
                        controller: _titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Trip name',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Enter trip name'
                                    : null,
                      ),
                      const SizedBox(height: 12),

                      // Origin & Destination
                      TextFormField(
                        controller: _originCtrl,
                        decoration: const InputDecoration(
                          labelText: 'From city',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) =>
                                (v == null || v.isEmpty)
                                    ? 'Enter origin'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _destCtrl,
                        decoration: const InputDecoration(
                          labelText: 'To city',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (v) =>
                                (v == null || v.isEmpty)
                                    ? 'Enter destination'
                                    : null,
                      ),
                      const SizedBox(height: 12),

                      // Dates
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _pickDate(isStart: true),
                              child: Text(
                                _start == null
                                    ? 'Pick start date'
                                    : df.format(_start!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  _hasReturn
                                      ? () => _pickDate(isStart: false)
                                      : null,
                              child: Text(
                                _end == null
                                    ? 'Pick return date'
                                    : df.format(_end!),
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

                      // Tags
                      const Text('Tags'),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children:
                            _allTags.map((tag) {
                              final sel = _selectedTags.contains(tag);
                              return FilterChip(
                                label: Text(tag),
                                selected: sel,
                                onSelected:
                                    (_) => setState(() {
                                      sel
                                          ? _selectedTags.remove(tag)
                                          : _selectedTags.add(tag);
                                    }),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      TextFormField(
                        controller: _notesCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Route & Date
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cs.primaryContainer,
                      child: const Icon(Icons.route, color: Colors.white),
                    ),
                    title: Text(
                      '${trip.origin} → ${trip.destination}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      daysUntil >= 0 && daysUntil < 14
                          ? 'Trip in $daysUntil day${daysUntil == 1 ? '' : 's'}'
                          : df.format(trip.start) +
                              (trip.end != null
                                  ? ' – ${df.format(trip.end!)}'
                                  : ''),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Attachments
                  Text(
                    'Attachments',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (trip.attachmentPaths.isEmpty)
                    const Text('No files attached.')
                  else
                    ...trip.attachmentPaths.map((path) {
                      final name = p.basename(path);
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.attach_file),
                          title: Text(name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_forever),
                            onPressed: () {
                              final updated = [...trip.attachmentPaths]
                                ..remove(path);
                              ref
                                  .read(tripRepoProvider.notifier)
                                  .update(
                                    trip.copyWith(attachmentPaths: updated),
                                  );
                            },
                          ),
                          onTap: () => _openAttachment(path),
                        ),
                      );
                    }),
                  FilledButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Add Attachment'),
                    onPressed: () => _addAttachment(trip),
                  ),
                  const SizedBox(height: 16),

                  // Photo & Ticket
                  if (trip.photoUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(trip.photoUrl!, fit: BoxFit.cover),
                    ),
                  if (trip.ticketUrl != null)
                    ListTile(
                      leading: const Icon(Icons.airplane_ticket),
                      title: const Text('Open tickets'),
                      subtitle: Text(trip.ticketUrl!),
                      onTap: () => _openUrl(trip.ticketUrl!),
                    ),
                  if (trip.photoUrl != null || trip.ticketUrl != null)
                    const SizedBox(height: 16),

                  // Tags
                  if (trip.tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 6,
                      children:
                          trip.tags
                              .map(
                                (t) => Chip(
                                  label: Text(t),
                                  backgroundColor: cs.secondaryContainer,
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Baggage checklist
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.checklist),
                      title: const Text('Open baggage checklist'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BaggagePage(tripId: trip.id),
                            ),
                          ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Notes
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notes',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(trip.notes.isEmpty ? '—' : trip.notes),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
