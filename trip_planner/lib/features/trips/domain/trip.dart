import 'package:uuid/uuid.dart';

class Trip {
  Trip({
    required this.title,
    required this.tags,
    required this.start,
    this.end,
    String? id,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final List<String> tags; // e.g. ['vacation']
  final DateTime start;
  final DateTime? end;
}
