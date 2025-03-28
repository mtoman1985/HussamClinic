import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:hussam_clinc/model/accounting/journals/IndexModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DbIndex {
  DbHelper dbHelper = DbHelper();
  Future<List<IndexModel>> allAccountingIndexes() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from indexes';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => IndexModel.fromMap(e)).toList();
  }


  Future<void> adddate(
      String date_kind,
      String date_place,
      String date_dateStart,
      String date_dateEnd,
      String date_note,
      String date_doctorId,
      String date_doctorName,
      String date_costumerId,
      String date_costumerName,
      ) async {
    Database? db = await dbHelper.openDb();
        return db!.execute(
        'INSERT INTO dates (date_kind, date_place, date_dateStart , date_dateEnd, date_note,date_doctorId ,date_doctorName, date_costumerId, date_costumerName) VALUES ("$date_kind","$date_place","$date_dateStart","$date_dateEnd","$date_note","$date_doctorId","$date_doctorName","$date_costumerId","$date_costumerName");');
  }
}
