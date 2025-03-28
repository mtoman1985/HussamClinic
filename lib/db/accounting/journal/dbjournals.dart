import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:hussam_clinc/model/accounting/journals/journalsModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DbJournals {
  DbHelper dbHelper = DbHelper();

  // CREATE TABLE "journals" (
  // "journal_id"	INTEGER NOT NULL UNIQUE,
  // "journal_date"	TEXT DEFAULT 'تاريخ القيد',
  // "journal_time"	TEXT DEFAULT 'وقت القيد',
  // "journal_amount"	TEXT DEFAULT 'مبلغ القيد',
  // "journal_currency"	TEXT DEFAULT 'العملة',
  // "journal_rate"	TEXT DEFAULT 'التحويل',
  // "journal_description"	TEXT DEFAULT 'الوصف',
  // PRIMARY KEY("journal_id" AUTOINCREMENT)
  // );

  Future<List<JournalsModel>> allJournals() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from journals ';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => JournalsModel.fromMap(e)).toList();
  }


  Future <JournalsModel> findJournals(String id) async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from journals WHERE journal_id=$id ';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return JournalsModel.fromMap(queryResult.first) ;
  }

  updatejournals(
      String journal_date, String journal_time,
      String journal_amount,String journal_currency,
      String journal_rate,  String journal_description,String journal_id
      ) async {
    Database? db = await dbHelper.openDb();
    String sql ='UPDATE journals SET journal_date="$journal_date",journal_time="$journal_time",journal_amount="$journal_amount",journal_currency="$journal_currency",journal_rate="$journal_rate" ,journal_description="$journal_description"  WHERE journal_id="$journal_id"';
    db!.rawQuery(sql);
  }

  Future<void> addjournals(
      String _date,
      String _time,
      String _amount,
      String _currency,
      String _rate,
      String _description,
      ) async {
    Database? db = await dbHelper.openDb();
    return db!.execute(
        'INSERT INTO journals (journal_date, journal_time, journal_amount , journal_currency, journal_rate, journal_description) VALUES ("$_date","$_time","$_amount","$_currency","$_rate","$_description");');
  }
}
