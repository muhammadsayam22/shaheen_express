class Ticket {
  final int? id;
  final String busName;
  final String from;
  final String to;
  final String time;
  final String price;
  final String status;
  final String createdAt;

  const Ticket({
    this.id,
    required this.busName,
    required this.from,
    required this.to,
    required this.time,
    required this.price,
    this.status = 'active',
    required this.createdAt,
  });

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'] as int?,
      busName: map['bus_name'] as String? ?? '',
      from: map['origin'] as String? ?? '',
      to: map['destination'] as String? ?? '',
      time: map['time'] as String? ?? '',
      price: map['price'] as String? ?? '',
      status: map['status'] as String? ?? 'active',
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'bus_name': busName,
      'origin': from,
      'destination': to,
      'time': time,
      'price': price,
      'status': status,
      'created_at': createdAt,
    };
  }

  Ticket copyWithId(int newId) {
    return Ticket(
      id: newId,
      busName: busName,
      from: from,
      to: to,
      time: time,
      price: price,
      status: status,
      createdAt: createdAt,
    );
  }
}
