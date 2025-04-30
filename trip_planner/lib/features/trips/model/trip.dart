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
    this.attachmentPaths = const [],
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

  /// Paths or names of user-selected files
  final List<String> attachmentPaths;

  Trip copyWith({
    String? title,
    String? origin,
    String? destination,
    DateTime? start,
    DateTime? end,
    bool? hasReturn,
    List<String>? tags,
    String? notes,
    String? ticketUrl,
    String? photoUrl,
    String? returnTripId,
    List<String>? attachmentPaths,
    String? id,
  }) {
    return Trip(
      title: title ?? this.title,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      start: start ?? this.start,
      end: end ?? this.end,
      hasReturn: hasReturn ?? this.hasReturn,
      tags: tags ?? List.from(this.tags),
      notes: notes ?? this.notes,
      ticketUrl: ticketUrl ?? this.ticketUrl,
      photoUrl: photoUrl ?? this.photoUrl,
      returnTripId: returnTripId ?? this.returnTripId,
      attachmentPaths: attachmentPaths ?? List.from(this.attachmentPaths),
      id: id ?? this.id,
    );
  }
}
