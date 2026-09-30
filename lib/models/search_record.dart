class SearchRecord {
  final int? id;
  final String origin;
  final String destination;
  final String date;
  final String returnDate;
  final String createdAt;

  const SearchRecord({
    this.id,
    required this.origin,
    required this.destination,
    required this.date,
    required this.returnDate,
    required this.createdAt,
  });

  factory SearchRecord.fromMap(Map<String, dynamic> map) {
    return SearchRecord(
      id: map['id'] as int?,
      origin: map['origin'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      date: map['date'] as String? ?? '',
      returnDate: map['return_date'] as String? ?? '',
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'origin': origin,
      'destination': destination,
      'date': date,
      'return_date': returnDate,
      'created_at': createdAt,
    };
  }

  SearchRecord copyWithId(int newId) {
    return SearchRecord(
      id: newId,
      origin: origin,
      destination: destination,
      date: date,
      returnDate: returnDate,
      createdAt: createdAt,
    );
  }
}
