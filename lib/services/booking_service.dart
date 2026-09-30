import 'package:flutter_application_14/database/database_helper.dart';
import 'package:flutter_application_14/models/booking.dart';

class BookingService {
  BookingService._();

  static final BookingService instance = BookingService._();

  static const String _table = 'bookings';

  Future<Booking?> createBooking({
    required String passengerName,
    required String phone,
    required int seatNumber,
  }) async {
    final Booking booking = Booking(
      passengerName: passengerName,
      phone: phone,
      seatNumber: seatNumber,
      createdAt: DateTime.now().toIso8601String(),
    );

    final int? id =
        await DatabaseHelper.instance.insert(_table, booking.toMap());
    if (id == null) return null;
    return booking.copyWithId(id);
  }

  Future<List<Booking>> getBookings() async {
    final List<Map<String, dynamic>> rows = await DatabaseHelper.instance
        .query(_table, orderBy: 'id DESC');
    return rows.map(Booking.fromMap).toList();
  }

  Future<List<int>> getBookedSeatNumbers() async {
    final List<Map<String, dynamic>> rows = await DatabaseHelper.instance
        .rawQuery('SELECT seat_number FROM $_table ORDER BY seat_number');
    final List<int> seats = <int>[];
    for (final Map<String, dynamic> row in rows) {
      final Object? seat = row['seat_number'];
      if (seat is num) seats.add(seat.toInt());
    }
    return seats;
  }

  Future<bool> deleteBooking(int id) async {
    final int? removed = await DatabaseHelper.instance
        .delete(_table, where: 'id = ?', whereArgs: <Object?>[id]);
    return removed != null && removed > 0;
  }
}
