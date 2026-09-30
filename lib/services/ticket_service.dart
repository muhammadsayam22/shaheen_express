import 'package:flutter_application_14/database/database_helper.dart';
import 'package:flutter_application_14/models/ticket.dart';

class TicketService {
  TicketService._();

  static final TicketService instance = TicketService._();

  static const String _table = 'tickets';

  Future<Ticket?> createTicket({
    required String busName,
    required String origin,
    required String destination,
    required String time,
    required String price,
  }) async {
    final Ticket ticket = Ticket(
      busName: busName,
      from: origin,
      to: destination,
      time: time,
      price: price,
      createdAt: DateTime.now().toIso8601String(),
    );

    final int? id =
        await DatabaseHelper.instance.insert(_table, ticket.toMap());
    if (id == null) return null;
    return ticket.copyWithId(id);
  }

  Future<List<Ticket>> getTickets() async {
    final List<Map<String, dynamic>> rows =
        await DatabaseHelper.instance.query(_table, orderBy: 'id DESC');
    return rows.map(Ticket.fromMap).toList();
  }

  Future<bool> deleteTicket(int id) async {
    final int? removed = await DatabaseHelper.instance
        .delete(_table, where: 'id = ?', whereArgs: <Object?>[id]);
    return removed != null && removed > 0;
  }
}
