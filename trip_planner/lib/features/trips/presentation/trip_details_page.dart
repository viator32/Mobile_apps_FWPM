import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../baggage/presentation/baggage_page.dart';
import '../data/trip_repository.dart';
import '../model/trip.dart';

class TripDetailsPage extends ConsumerWidget {
  const TripDetailsPage({required this.tripId, super.key});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(tripRepoProvider).firstWhere((t) => t.id == tripId);
    final df = DateFormat.yMMMd();
    final diff = trip.start.difference(DateTime.now()).inDays;
    final cs = Theme.of(context).colorScheme;

    void _removeTrip() {
      ref.read(tripRepoProvider.notifier).remove(trip.id);
      Navigator.pop(context);
    }

    Future<void> _addAttachment() async {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        // on Web, file.path is null; use name instead
        final pathOrName = file.path ?? file.name;
        final updated = List<String>.from(trip.attachmentPaths)
          ..add(pathOrName);
        ref
            .read(tripRepoProvider.notifier)
            .update(trip.copyWith(attachmentPaths: updated));
      }
    }

    Future<void> _openAttachment(String path) async {
      if (kIsWeb) {
        // On Web attachments are just names; no-op or implement download
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot open local files on Web.')),
        );
      } else {
        await OpenFile.open(path);
      }
    }

    Future<void> _openUrl(String url) async {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              /* TODO */
            },
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: _removeTrip),
        ],
      ),
      body: ListView(
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
              diff >= 0 && diff < 14
                  ? 'Trip in $diff day${diff == 1 ? '' : 's'}'
                  : df.format(trip.start) +
                      (trip.end != null ? ' – ${df.format(trip.end!)}' : ''),
            ),
          ),
          const SizedBox(height: 16),

          // Attachments Section
          Text('Attachments', style: Theme.of(context).textTheme.titleMedium),
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
                      final updated = List<String>.from(trip.attachmentPaths)
                        ..remove(path);
                      ref
                          .read(tripRepoProvider.notifier)
                          .update(trip.copyWith(attachmentPaths: updated));
                    },
                  ),
                  onTap: () => _openAttachment(path),
                ),
              );
            }),
          FilledButton.icon(
            icon: const Icon(Icons.upload_file),
            label: const Text('Add Attachment'),
            onPressed: _addAttachment,
          ),
          const SizedBox(height: 16),

          // Photo / Ticket URL
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
          const SizedBox(height: 8),

          // Return trip link
          if (trip.returnTripId != null)
            Card(
              color: cs.tertiaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.undo),
                title: const Text('View return trip'),
                trailing: const Icon(Icons.chevron_right),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => TripDetailsPage(tripId: trip.returnTripId!),
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
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
