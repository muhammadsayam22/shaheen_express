import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Owns the local SQLite connection for Shaheen Express.
///
/// The database file is created only when it does not exist yet and the
/// default bus/route records are inserted once, so existing data is never
/// duplicated or removed on restart.
class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String databaseName = 'shaheen_express.db';
  static const int databaseVersion = 1;

  Database? _database;

  Future<Database?> get database async {
    if (_database != null && _database!.isOpen) {
      return _database;
    }
    try {
      final String path = p.join(await getDatabasesPath(), databaseName);
      _database = await openDatabase(
        path,
        version: databaseVersion,
        onCreate: _onCreate,
        onOpen: _onOpen,
      );
      return _database;
    } catch (error, stackTrace) {
      debugPrint('DatabaseHelper: unable to open database -> $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS buses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS routes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bus_id INTEGER NOT NULL,
        origin TEXT NOT NULL,
        destination TEXT NOT NULL,
        time TEXT NOT NULL,
        price TEXT NOT NULL,
        FOREIGN KEY (bus_id) REFERENCES buses (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        passenger_name TEXT NOT NULL,
        phone TEXT NOT NULL DEFAULT '',
        seat_number INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS tickets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bus_name TEXT NOT NULL,
        origin TEXT NOT NULL,
        destination TEXT NOT NULL,
        time TEXT NOT NULL,
        price TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'active',
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS complaints (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        message TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS job_applications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        job_title TEXT NOT NULL,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        message TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        origin TEXT NOT NULL,
        destination TEXT NOT NULL,
        date TEXT NOT NULL,
        return_date TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        setting_key TEXT PRIMARY KEY,
        setting_value TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onOpen(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    await _seedIfEmpty(db);
  }

  Future<void> _seedIfEmpty(Database db) async {
    try {
      final List<Map<String, dynamic>> count =
          await db.rawQuery('SELECT COUNT(*) AS total FROM buses');
      final int total = (count.first['total'] as num?)?.toInt() ?? 0;
      if (total > 0) return;

      await db.transaction((txn) async {
        for (final Map<String, String> bus in _defaultBuses) {
          final int busId = await txn.insert('buses', {'name': bus['name']});
          await txn.insert('routes', {
            'bus_id': busId,
            'origin': bus['from'],
            'destination': bus['to'],
            'time': bus['time'],
            'price': bus['price'],
          });
        }
      });
    } catch (error) {
      debugPrint('DatabaseHelper: seeding failed -> $error');
    }
  }

  static const List<Map<String, String>> _defaultBuses = [
    {
      'name': 'Shaheen Express',
      'from': 'Kohat',
      'to': 'pindi',
      'time': '16 Hours Service',
      'price': 'Rs. 1000',
    },
    {
      'name': 'Shaheen Express ',
      'from': 'kohat',
      'to': 'Karachi',
      'time': 'AM 9:00',
      'price': 'Rs. 5000',
    },
    {
      'name': 'Shaheen Luxury Liner',
      'from': 'Faisalabad',
      'to': 'Multan',
      'time': '11:30 AM',
      'price': 'Rs. 1,800',
    },
    {
      'name': 'Shaheen Executive',
      'from': 'Rawalpindi',
      'to': 'Peshawar',
      'time': '02:15 PM',
      'price': 'Rs. 1,200',
    },
  ];

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final Database? db = await database;
    if (db == null) return const [];
    try {
      return await db.rawQuery(sql, arguments);
    } on Exception catch (error) {
      debugPrint('DatabaseHelper.rawQuery failed -> $error');
      return const [];
    }
  }

  Future<int?> rawInsert(String sql, [List<Object?>? arguments]) async {
    final Database? db = await database;
    if (db == null) return null;
    try {
      return await db.rawInsert(sql, arguments);
    } on Exception catch (error) {
      debugPrint('DatabaseHelper.rawInsert failed -> $error');
      return null;
    }
  }

  Future<int?> rawDelete(String sql, [List<Object?>? arguments]) async {
    final Database? db = await database;
    if (db == null) return null;
    try {
      return await db.rawDelete(sql, arguments);
    } on Exception catch (error) {
      debugPrint('DatabaseHelper.rawDelete failed -> $error');
      return null;
    }
  }

  Future<int?> insert(String table, Map<String, dynamic> values) async {
    final Database? db = await database;
    if (db == null) return null;
    try {
      return await db.insert(table, values);
    } on Exception catch (error) {
      debugPrint('DatabaseHelper.insert($table) failed -> $error');
      return null;
    }
  }

  Future<int?> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final Database? db = await database;
    if (db == null) return null;
    try {
      return await db.update(table, values, where: where, whereArgs: whereArgs);
    } on Exception catch (error) {
      debugPrint('DatabaseHelper.update($table) failed -> $error');
      return null;
    }
  }

  Future<int?> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final Database? db = await database;
    if (db == null) return null;
    try {
      return await db.delete(table, where: where, whereArgs: whereArgs);
    } on Exception catch (error) {
      debugPrint('DatabaseHelper.delete($table) failed -> $error');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? orderBy,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final Database? db = await database;
    if (db == null) return const [];
    try {
      return await db.query(
        table,
        orderBy: orderBy,
        where: where,
        whereArgs: whereArgs,
      );
    } on Exception catch (error) {
      debugPrint('DatabaseHelper.query($table) failed -> $error');
      return const [];
    }
  }

  Future<String?> getSetting(String key) async {
    final List<Map<String, dynamic>> rows = await rawQuery(
      'SELECT setting_value FROM settings WHERE setting_key = ?',
      <Object?>[key],
    );
    if (rows.isEmpty) return null;
    return rows.first['setting_value'] as String?;
  }

  Future<bool> setSetting(String key, String value) async {
    final int? id = await rawInsert(
      'INSERT INTO settings (setting_key, setting_value) VALUES (?, ?) '
      'ON CONFLICT(setting_key) DO UPDATE SET setting_value = excluded.setting_value',
      <Object?>[key, value],
    );
    return id != null;
  }

  Future<void> reseedBuses() async {
    final Database? db = await database;
    if (db == null) return;
    await _seedIfEmpty(db);
  }

  Future<void> close() async {
    try {
      await _database?.close();
    } on Exception catch (error) {
      debugPrint('DatabaseHelper.close failed -> $error');
    } finally {
      _database = null;
    }
  }
}
