import 'package:sqflite/sqlite_api.dart';

class DBSingleton {
  late Future<Database> db;
  static final DBSingleton _inst = DBSingleton._internal();

  factory DBSingleton({Future<Database>? db}) {
    if (db != null) _inst.db = db;
    return _inst;
  }

  DBSingleton._internal();
}
