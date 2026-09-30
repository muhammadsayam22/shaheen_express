class JobApplication {
  final int? id;
  final String jobTitle;
  final String name;
  final String phone;
  final String message;
  final String createdAt;

  const JobApplication({
    this.id,
    required this.jobTitle,
    required this.name,
    required this.phone,
    required this.message,
    required this.createdAt,
  });

  factory JobApplication.fromMap(Map<String, dynamic> map) {
    return JobApplication(
      id: map['id'] as int?,
      jobTitle: map['job_title'] as String? ?? '',
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      message: map['message'] as String? ?? '',
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'job_title': jobTitle,
      'name': name,
      'phone': phone,
      'message': message,
      'created_at': createdAt,
    };
  }

  JobApplication copyWithId(int newId) {
    return JobApplication(
      id: newId,
      jobTitle: jobTitle,
      name: name,
      phone: phone,
      message: message,
      createdAt: createdAt,
    );
  }
}
