import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
class DbVouchers {
  DbHelper dbHelper = DbHelper();

/*  CREATE TABLE "vouchers" (
  "voucher_id"	INTEGER NOT NULL UNIQUE,
  "voucher_no"	INTEGER,
  "voucher_date"	TEXT DEFAULT 'التاريخ',
  "voucher_time"	TEXT DEFAULT 'الساعة',
  "voucher_account"	TEXT DEFAULT 'الحساب/رقم الشخص',
  "voucher_dealer"	TEXT DEFAULT 'اسم الشخص',
  "voucher_payment"	TEXT DEFAULT 'المبلغ المدفوع',
  "voucher_currency"	TEXT DEFAULT 'العملة',
  "voucher_journal"	TEXT DEFAULT 'رقم القيد',
  "voucher_discription"	TEXT DEFAULT 'الوصف',
  "voucher_class"	TEXT DEFAULT 'صرف_قبض',
  PRIMARY KEY("voucher_id" AUTOINCREMENT)
  );*/

  Future<void> addVouchers(
      String _account_no ,
      String _date,
      String _time,
      String _account_name ,
      String _payment,
      String _payment_currency ,
      String _jornal ,
      String _discription ,
      String _type
      ) async {

    String Sql='INSERT INTO vouchers ( "voucher_date", "voucher_time", "voucher_account", "voucher_dealer", "voucher_payment", "voucher_currency", "voucher_journal", "voucher_discription", "voucher_class") VALUES ';
    Sql=Sql+'("$_date","$_time","$_account_no","$_account_name","$_payment","$_payment_currency","$_jornal","$_discription","$_type");';
    Database? db = await dbHelper.openDb();
    return db!.execute(Sql) ;
  }
}
