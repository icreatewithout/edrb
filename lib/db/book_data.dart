import 'package:edrb/db/sqlite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookData {
  late int? id;
  late String? bid;
  late String? cid;
  late String? name;
  late String? catalog;
  late String? txt;

  bool shelf = false;

  Map<String, dynamic> toMap() {
    var map = <String, Object?>{
      'id': id,
      'bid': bid,
      'cid': cid,
      'name': name,
      'catalog': catalog,
      'txt': txt,
      'shelf': shelf,
    };
    return map;
  }

  BookData(this.bid, this.cid, this.name, this.catalog, this.txt);

  BookData.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    bid = map['bid'];
    cid = map['cid'];
    name = map['name'];
    catalog = map['catalog'];
    txt = map['txt'];
    shelf = map['shelf'] == 1 ? true : false;
  }
}

class BookDataProvider {
  final SqliteDb sqliteDb = SqliteDb();

  Future<BookData?> insert(BookData bd) async {
    BookData? bookData = await get(bd.bid!, bd.cid!);
    if (bookData == null) {
      print(bd.catalog);
      bd.id = await sqliteDb.db?.insert('book_data', bd.toMap());
      return bd;
    }
    return null;
  }

  Future<BookData?> get(String bid, String cid) async {
    List<Map> maps = await sqliteDb.db!.query('book_data',
        columns: ['id', 'bid', 'cid', 'name', 'catalog', 'txt', 'shelf'],
        where: 'bid = ? and cid = ?',
        whereArgs: [bid, cid]);
    if (maps.isNotEmpty) {
      return BookData.fromMap(maps.first);
    }
    return null;
  }

  Future<BookData?> getByBid(String bid) async {
    List<Map> maps = await sqliteDb.db!.query(
      'book_data',
      columns: ['id', 'bid', 'cid', 'name', 'catalog', 'txt', 'shelf'],
      where: 'bid = ?',
      whereArgs: [bid],
      orderBy: 'id desc',
    );
    if (maps.isNotEmpty) {
      return BookData.fromMap(maps.first);
    }
    return null;
  }

  Future<String?> prev(String bid, String cid) async {
    List<Map> maps = await sqliteDb.db!.query(
      'book_data',
      columns: ['id', 'bid', 'cid', 'name', 'catalog', 'txt', 'shelf'],
      where: 'bid = ? and cid < ?',
      whereArgs: [bid, cid],
      orderBy: 'cid desc',
    );
    if (maps.isNotEmpty) {
      return BookData.fromMap(maps.first).cid;
    }
    return null;
  }

  Future<String?> next(String bid, String cid) async {
    List<Map> maps = await sqliteDb.db!.query(
      'book_data',
      columns: ['id', 'bid', 'cid', 'name', 'catalog', 'txt', 'shelf'],
      where: 'bid = ? and cid > ?',
      whereArgs: [bid, cid],
      orderBy: 'cid asc',
    );
    if (maps.isNotEmpty) {
      return BookData.fromMap(maps.first).cid;
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await sqliteDb.db!
        .delete('book_data', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    await sqliteDb.db!.delete('book_data');
  }

  Future<int> update(BookData bd) async {
    return await sqliteDb.db!
        .update('book_data', bd.toMap(), where: 'id = ?', whereArgs: [bd.id]);
  }

  Future close() async => sqliteDb.db!.close();
}
