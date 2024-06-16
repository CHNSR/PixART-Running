import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../model/entry.dart';

abstract class DB {
  static Database? _db;
  static int get _version => 1;

  static Future<void> init() async {
    try {
      String _path = await getDatabasesPath();
      String _dbpath = p.join(_path, 'database.db');
      _db = await openDatabase(_dbpath, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static FutureOr<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT, 
        duration TEXT, 
        speed REAL, 
        distance REAL
      )
    ''');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    if (_db == null) {
      throw Exception("Database is not initialized.");
    }
    return await _db!.query(table);
  }

  static Future<int> insert(String table, Entry item) async {
    if (_db == null) {
      throw Exception("Database is not initialized.");
    }
    return await _db!.insert(table, item.toMap());
  }
}
