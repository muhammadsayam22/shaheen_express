import 'package:flutter_application_14/database/database_helper.dart';
import 'package:flutter_application_14/models/search_record.dart';

class SearchService {
  SearchService._();

  static final SearchService instance = SearchService._();

  static const String _table = 'search_history';

  Future<SearchRecord?> saveSearch({
    required String origin,
    required String destination,
    required String date,
    required String returnDate,
  }) async {
    final SearchRecord record = SearchRecord(
      origin: origin,
      destination: destination,
      date: date,
      returnDate: returnDate,
      createdAt: DateTime.now().toIso8601String(),
    );

    final int? id =
        await DatabaseHelper.instance.insert(_table, record.toMap());
    if (id == null) return null;
    return record.copyWithId(id);
  }

  Future<List<SearchRecord>> getHistory() async {
    final List<Map<String, dynamic>> rows =
        await DatabaseHelper.instance.query(_table, orderBy: 'id DESC');
    return rows.map(SearchRecord.fromMap).toList();
  }

  Future<bool> clearHistory() async {
    final int? removed = await DatabaseHelper.instance.delete(_table);
    return removed != null;
  }
}
