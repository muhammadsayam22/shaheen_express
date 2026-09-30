class Complaint {
  final int? id;
  final String name;
  final String phone;
  final String message;
  final String createdAt;

  const Complaint({
    this.id,
    required this.name,
    required this.phone,
    required this.message,
    required this.createdAt,
  });

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      message: map['message'] as String? ?? '',
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'message': message,
      'created_at': createdAt,
    };
  }

  Complaint copyWithId(int newId) {
    return Complaint(
      id: newId,
      name: name,
      phone: phone,
      message: message,
      createdAt: createdAt,
    );
  }
}
