import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Trip {
  Trip({
    required this.title,
    required this.origin,
    required this.destination,
    required this.start,
    this.end,
    this.hasReturn = false,
    this.tags = const [],
    this.notes = '',
    this.ticketUrl,
    this.photoUrl,
    this.returnTripId,
    String? id,
  }) : id = id ?? _uuid.v4();

  final String id;
  final String title;
  final String origin;
  final String destination;
  final DateTime start;
  final DateTime? end;
  final bool hasReturn;
  final List<String> tags;
  final String notes;
  final String? ticketUrl;
  final String? photoUrl;
  final String? returnTripId;
}
