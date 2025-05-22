import 'package:uuid/uuid.dart';
import 'dart:convert';

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
    this.pinned = false,
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
  final List<String> attachmentPaths;
  final bool pinned;

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
    bool? pinned,
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
      pinned: pinned ?? this.pinned,
      id: id ?? this.id,
    );
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] as String,
      title: map['title'] as String,
      origin: map['origin'] as String,
      destination: map['destination'] as String,
      start: DateTime.fromMillisecondsSinceEpoch(map['start'] as int),
      end:
          map['end'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['end'] as int)
              : null,
      hasReturn: (map['hasReturn'] as int) == 1,
      tags: (jsonDecode(map['tags'] as String) as List<dynamic>).cast<String>(),
      notes: map['notes'] as String,
      ticketUrl: map['ticketUrl'] as String?,
      photoUrl: map['photoUrl'] as String?,
      returnTripId: map['returnTripId'] as String?,
      attachmentPaths:
          (jsonDecode(map['attachmentPaths'] as String) as List<dynamic>)
              .cast<String>(),
      pinned: (map['pinned'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'origin': origin,
      'destination': destination,
      'start': start.millisecondsSinceEpoch,
      'end': end?.millisecondsSinceEpoch,
      'hasReturn': hasReturn ? 1 : 0,
      'returnTripId': returnTripId,
      'tags': jsonEncode(tags),
      'notes': notes,
      'ticketUrl': ticketUrl,
      'photoUrl': photoUrl,
      'attachmentPaths': jsonEncode(attachmentPaths),
      'pinned': pinned ? 1 : 0,
    };
  }
}
