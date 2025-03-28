import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:hussam_clinc/model/accounting/journals/JournalsDetailModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../../../main.dart';

class DbJournalDetails {
  DbHelper dbHelper = DbHelper();

  Future<void> MaxNoS() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from sqlite_sequence';
    final List<Map<String, Object?>> queryResult = await db!.rawQuery(sql);
    int max=0;
    for (var element in queryResult) {
      max=(int.parse(element.entries.elementAt(1).value.toString())+1);
      if(element.entries.elementAt(0).value=='journals'){
        VMGlobal.Maxjournals =max.toString();
        //Maxjournals=max.toString();
        //Maxjournals=(int.parse(Maxjournals)+1).toString();
      }
      if(element.entries.elementAt(0).value=='vouchers'){
        VMGlobal.MaxVouchers  =max.toString();
        // MaxVouchers=max.toString();
        //MaxVouchers=(int.parse(MaxVouchers)+1).toString();
      }
      if(element.entries.elementAt(0).value=='invoices'){
        VMGlobal.MaxInvoices  =max.toString();
        // MaxInvoices=max.toString();
        //  MaxInvoices=(int.parse(MaxInvoices)+1).toString();
      }
    }
  }

  /*CREATE TABLE "journals_detail" (
  "JD_id"	INTEGER NOT NULL UNIQUE,
  "JD_journal_id"	TEXT DEFAULT 'رقم القيد',
  "JD_account_id"	TEXT DEFAULT 'رقم الحساب',
  "JD_account_name"	TEXT DEFAULT 'اسم الحساب',
  "JD_debit"	TEXT DEFAULT 'مدين',
  "JD_credit"	TEXT DEFAULT 'دائن',
  "JD_description"	TEXT DEFAULT 'الوصف',
  "JD_currency"	TEXT DEFAULT 'العملة',
  "JD_rate"	TEXT DEFAULT 'سعر العملة',
  "JD_acc_amount"	TEXT DEFAULT 'مبلغ الحساب',*/

  Future<void> addjournalDetails(
      String _journal_id,
      String _account_id,
      String _account_name,
      String _debit,
      String _credit,
      String _description,
      String _currency,
      String _rate,
      String _acc_amount,
      ) async {
    Database? db = await dbHelper.openDb();
    return db!.execute(
        'INSERT INTO journals_detail (JD_journal_id, JD_account_id, JD_account_name , JD_debit, JD_credit, JD_description,JD_currency,JD_rate,JD_acc_amount) VALUES ("$_journal_id","$_account_id","$_account_name","$_debit","$_credit","$_description","$_currency","$_rate","$_acc_amount");');
  }

  Future<List<JournalsDetailModel>> searchJournalsDetail(String id) async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from journals_detail WHERE JD_journal_id=$id ';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => JournalsDetailModel.fromMap(e)).toList();
  }

  updatejournalDetails(
      String _journal_id,
      String _account_id,
      String _account_name,
      String _debit,
      String _credit,
      String _description,
      String _currency,
      String _rate,
      String _acc_amount
      ) async {
    Database? db = await dbHelper.openDb();
    String sql ='UPDATE journals_detail SET JD_journal_id="$_journal_id",JD_account_id="$_account_id",JD_account_name="$_account_name"';
    sql=sql+' ,JD_debit="$_debit" ,JD_credit="$_credit" ,JD_description="$_description" ,JD_currency="$_currency" ';
     sql=sql+' ,JD_rate="$_rate"  ,JD_acc_amount="$_acc_amount"  WHERE JD_journal_id="$_journal_id"';
    db!.rawQuery(sql);
  }

}
