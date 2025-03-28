import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:hussam_clinc/model/DatesModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DbDate {
  DbHelper dbHelper = DbHelper();

  Future<List<DateModel>> alldate() async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from dates ORDER by date_id ASC';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => DateModel.fromMap(e)).toList();
  }

  Future<DateModel>  lastDate() async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from dates ORDER by date_id DESC LIMIT 1';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return DateModel.fromMap(queryResult.first) ;
  }

  Future<DateModel> searchDatesById(String id) async {
    int id0= int.parse(id);
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from dates WHERE date_id=$id0 LIMIT 1';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    //queryResult!.firstOrNull;
    return DateModel.fromMap(queryResult[0]) ;
  }

  Future<List<DateModel>> GroupDates() async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from group_date';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => DateModel.fromMap(e)).toList();
  }


  deletedate(int id) async {
    Database? db = await dbHelper.openDb();
    String sql = 'DELETE FROM dates  WHERE date_id=$id';
    db!.rawQuery(sql);
  }

  updateDate(int id,DateModel DateModle ) async {
    Database? db = await dbHelper.openDb();
    db!.update ("dates", DateModle.toMap(),
        where: 'date_id = ?', whereArgs: [id]);
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
