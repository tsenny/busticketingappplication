import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper {
  static Future<Database> db() async {
    return openDatabase(
      join(await getDatabasesPath(), 'busticketing.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tickets(id INTEGER PRIMARY KEY, pickup TEXT, destination TEXT, fare REAL, luggageFare REAL, discount REAL, total REAL, date TEXT, time TEXT, conductor TEXT, ticketNumber TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<int> addTicket(Map<String, dynamic> ticket) async {
    final db = await SQLHelper.db();
    return await db.insert('tickets', ticket, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getTickets() async {
    final db = await SQLHelper.db();
    return db.query('tickets');
  }

  static Future<void> deleteTicket(int id) async {
    final db = await SQLHelper.db();
    await db.delete('tickets', where: 'id = ?', whereArgs: [id]);
  }
}
