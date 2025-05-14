class BaggageItem {
  final int? id;
  final String tripId;
  String name;
  bool checked;
  int position;

  BaggageItem({
    this.id,
    required this.tripId,
    required this.name,
    this.checked = false,
    this.position = 0,
  });

  factory BaggageItem.fromMap(Map<String, dynamic> map) => BaggageItem(
    id: map['id'] as int?,
    tripId: map['tripId'] as String,
    name: map['name'] as String,
    checked: (map['checked'] as int) == 1,
    position: map['position'] as int,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'tripId': tripId,
    'name': name,
    'checked': checked ? 1 : 0,
    'position': position,
  };
}
