import 'package:flutter_application_14/database/database_helper.dart';
import 'package:flutter_application_14/models/complaint.dart';

class ComplaintService {
  ComplaintService._();

  static final ComplaintService instance = ComplaintService._();

  static const String _table = 'complaints';

  Future<Complaint?> saveComplaint({
    required String name,
    required String phone,
    required String message,
  }) async {
    final Complaint complaint = Complaint(
      name: name,
      phone: phone,
      message: message,
      createdAt: DateTime.now().toIso8601String(),
    );

    final int? id =
        await DatabaseHelper.instance.insert(_table, complaint.toMap());
    if (id == null) return null;
    return complaint.copyWithId(id);
  }

  Future<List<Complaint>> getComplaints() async {
    final List<Map<String, dynamic>> rows =
        await DatabaseHelper.instance.query(_table, orderBy: 'id DESC');
    return rows.map(Complaint.fromMap).toList();
  }

  Future<bool> deleteComplaint(int id) async {
    final int? removed = await DatabaseHelper.instance
        .delete(_table, where: 'id = ?', whereArgs: <Object?>[id]);
    return removed != null && removed > 0;
  }
}
