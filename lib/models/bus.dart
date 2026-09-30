class Bus {
  final int? routeId;
  final int? busId;
  final String name;
  final String from;
  final String to;
  final String time;
  final String price;

  const Bus({
    this.routeId,
    this.busId,
    required this.name,
    required this.from,
    required this.to,
    required this.time,
    required this.price,
  });

  factory Bus.fromMap(Map<String, dynamic> map) {
    return Bus(
      routeId: map['route_id'] as int?,
      busId: map['bus_id'] as int?,
      name: map['name'] as String? ?? '',
      from: map['origin'] as String? ?? '',
      to: map['destination'] as String? ?? '',
      time: map['time'] as String? ?? '',
      price: map['price'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'origin': from,
      'destination': to,
      'time': time,
      'price': price,
    };
  }

  Bus copyWith({
    int? routeId,
    int? busId,
    String? name,
    String? from,
    String? to,
    String? time,
    String? price,
  }) {
    return Bus(
      routeId: routeId ?? this.routeId,
      busId: busId ?? this.busId,
      name: name ?? this.name,
      from: from ?? this.from,
      to: to ?? this.to,
      time: time ?? this.time,
      price: price ?? this.price,
    );
  }
}
