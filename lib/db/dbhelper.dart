// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();
  factory DbHelper() => _instance;
  DbHelper.internal();
  Database? _db;

  void copyAssetsDb(String path) async {
    ////////////////////// Load database from asset and copy
    ByteData data = await rootBundle.load('assets/db/db.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // Save copied asset to documents
    await File(path).writeAsBytes(bytes);
    print('Successfully Copied DB');
  }

  void backupDb(String fromPath, String toPath) async {
    ////////////////////// Load database from asset and copy
    ByteData data = await rootBundle.load(fromPath);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // Save copied asset to documents
    await File(toPath).writeAsBytes(bytes);
    print('Successfully Backup DB');
    ////////////////////// end copy data base
  }

  Future<Database?> openDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'db.db');
    //copyAssetsDb(path);
    if (await databaseExists(path) == false) {
      copyAssetsDb(path);
    }
    _db = await openDatabase(path);
    return _db;
  }

  closeDB() async {
    final db = await _db;
    await db!.close();
  }

  // Future<int> createCourse(PersonModel person) async {
  //   Database? db = await openDb();
  //   //db.rawInsert('insert into courses')
  //   return db!.insert('persons', person.toMap());
  // }
}
