import 'package:flutter/foundation.dart';
import 'package:flutter_application_14/database/database_helper.dart';
import 'package:flutter_application_14/models/bus.dart';

class BusService {
  BusService._();

  static final BusService instance = BusService._();

  Future<List<Bus>> getBuses({String? origin, String? destination}) async {
    final String cleanOrigin = origin?.trim() ?? '';
    final String cleanDestination = destination?.trim() ?? '';

    final List<String> clauses = <String>[];
    final List<Object?> arguments = <Object?>[];

    if (cleanOrigin.isNotEmpty) {
      clauses.add('lower(r.origin) LIKE ?');
      arguments.add('%${cleanOrigin.toLowerCase()}%');
    }
    if (cleanDestination.isNotEmpty) {
      clauses.add('lower(r.destination) LIKE ?');
      arguments.add('%${cleanDestination.toLowerCase()}%');
    }

    final String whereClause =
        clauses.isEmpty ? '' : 'WHERE ${clauses.join(' AND ')}';

    final List<Map<String, dynamic>> rows =
        await DatabaseHelper.instance.rawQuery(
      'SELECT r.id AS route_id, r.bus_id AS bus_id, b.name AS name, '
      'r.origin AS origin, r.destination AS destination, '
      'r.time AS time, r.price AS price '
      'FROM routes r '
      'INNER JOIN buses b ON b.id = r.bus_id '
      '$whereClause '
      'ORDER BY r.id',
      arguments,
    );

    return rows.map(Bus.fromMap).toList();
  }

  Future<Bus?> getBus(int routeId) async {
    final List<Bus> buses = await getBuses();
    for (final Bus bus in buses) {
      if (bus.routeId == routeId) return bus;
    }
    return null;
  }

  Future<bool> addBus({
    required String name,
    required String origin,
    required String destination,
    required String time,
    required String price,
  }) async {
    final int? busId = await DatabaseHelper.instance
        .insert('buses', <String, dynamic>{'name': name});
    if (busId == null) return false;

    final int? routeId = await DatabaseHelper.instance
        .insert('routes', <String, dynamic>{
      'bus_id': busId,
      'origin': origin,
      'destination': destination,
      'time': time,
      'price': price,
    });
    return routeId != null;
  }

  Future<bool> updateRoute(
    int routeId, {
    required String origin,
    required String destination,
    required String time,
    required String price,
  }) async {
    final int? updated = await DatabaseHelper.instance.update(
      'routes',
      <String, dynamic>{
        'origin': origin,
        'destination': destination,
        'time': time,
        'price': price,
      },
      where: 'id = ?',
      whereArgs: <Object?>[routeId],
    );
    return updated != null && updated > 0;
  }

  Future<bool> deleteRoute(int routeId) async {
    final DatabaseHelper db = DatabaseHelper.instance;
    final List<Map<String, dynamic>> routes = await db.rawQuery(
      'SELECT bus_id FROM routes WHERE id = ?',
      <Object?>[routeId],
    );
    if (routes.isEmpty) return false;

    final Object? busId = routes.first['bus_id'];
    final int? removed = await db.rawDelete(
      'DELETE FROM routes WHERE id = ?',
      <Object?>[routeId],
    );
    await db.rawDelete(
      'DELETE FROM buses WHERE id = ? '
      'AND NOT EXISTS (SELECT 1 FROM routes WHERE bus_id = buses.id)',
      <Object?>[busId],
    );
    return removed != null && removed > 0;
  }

  Future<void> restoreDefaultBuses() async {
    final List<Bus> buses = await getBuses();
    if (buses.isNotEmpty) return;
    await DatabaseHelper.instance.delete('routes');
    await DatabaseHelper.instance.delete('buses');
    await DatabaseHelper.instance.reseedBuses();
    debugPrint('BusService: default buses restored');
  }
}
