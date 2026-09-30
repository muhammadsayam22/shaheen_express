import 'package:flutter_application_14/database/database_helper.dart';
import 'package:flutter_application_14/models/job_application.dart';

class JobApplicationService {
  JobApplicationService._();

  static final JobApplicationService instance = JobApplicationService._();

  static const String _table = 'job_applications';

  Future<JobApplication?> apply({
    required String jobTitle,
    required String name,
    required String phone,
    required String message,
  }) async {
    final JobApplication application = JobApplication(
      jobTitle: jobTitle,
      name: name,
      phone: phone,
      message: message,
      createdAt: DateTime.now().toIso8601String(),
    );

    final int? id =
        await DatabaseHelper.instance.insert(_table, application.toMap());
    if (id == null) return null;
    return application.copyWithId(id);
  }

  Future<List<JobApplication>> getApplications() async {
    final List<Map<String, dynamic>> rows =
        await DatabaseHelper.instance.query(_table, orderBy: 'id DESC');
    return rows.map(JobApplication.fromMap).toList();
  }

  Future<bool> deleteApplication(int id) async {
    final int? removed = await DatabaseHelper.instance
        .delete(_table, where: 'id = ?', whereArgs: <Object?>[id]);
    return removed != null && removed > 0;
  }
}
