import 'package:edrb/db/book_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDb {
  static late Database _db;
  static String dataBase = "edrb.tititxt.db";
  static int version = 1;

  static _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Database? get db => _db;

  Future<void> delete() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dataBase);
    return await deleteDatabase(path);
  }

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, SqliteDb.dataBase);
    _db = await openDatabase(
      path,
      version: SqliteDb.version,
      onCreate: (Database db, int version) {
        _bookData(db);
      },
      onUpgrade: _onUpgrade,
    );
  }

  void _bookData(Database db) {
    db.execute(
        '''
            CREATE TABLE IF NOT EXISTS book_data(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              bid TEXT,
              cid TEXT,
              name TEXT,
              catalog TEXT,
              txt TEXT,
              shelf BOOLEAN
            )
        '''
    );
  }
}
