import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../db.dart';
import '../models/handy_file.dart';

class HandyFilesRepo {
  static addHandyFileToDatabase(HandyFile handyFile) async {
    final db = await DBSingleton().db;
    var raw = await db.insert(
      "HandyFile",
      handyFile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  static updateHandyFile(HandyFile handyFile) async {
    final db = await DBSingleton().db;
    var response = await db.update("HandyFile", handyFile.toMap(),
        where: "id = ?", whereArgs: [handyFile.id]);
    return response;
  }

  static Future<HandyFile?> getHandyFileWithId(int id) async {
    final db = await DBSingleton().db;
    var response =
        await db.query("HandyFile", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? HandyFile.fromMap(response.first) : null;
  }

  static Future<List<HandyFile>> getAllHandyFiles() async {
    final db = await DBSingleton().db;
    var response = await db.query("HandyFile");
    List<HandyFile> list = response.map((c) => HandyFile.fromMap(c)).toList();
    return list;
  }

  static deleteHandyFileWithId(int id) async {
    final db = await DBSingleton().db;
    return db.delete("HandyFile", where: "id = ?", whereArgs: [id]);
  }

  static deleteAllHandyFiles() async {
    final db = await DBSingleton().db;
    db.delete("HandyFile");
  }
}
