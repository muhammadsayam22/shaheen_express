class Booking {
  final int? id;
  final String passengerName;
  final String phone;
  final int seatNumber;
  final String createdAt;

  const Booking({
    this.id,
    required this.passengerName,
    required this.phone,
    required this.seatNumber,
    required this.createdAt,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] as int?,
      passengerName: map['passenger_name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      seatNumber: (map['seat_number'] as num?)?.toInt() ?? 0,
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'passenger_name': passengerName,
      'phone': phone,
      'seat_number': seatNumber,
      'created_at': createdAt,
    };
  }

  Booking copyWithId(int newId) {
    return Booking(
      id: newId,
      passengerName: passengerName,
      phone: phone,
      seatNumber: seatNumber,
      createdAt: createdAt,
    );
  }
}
