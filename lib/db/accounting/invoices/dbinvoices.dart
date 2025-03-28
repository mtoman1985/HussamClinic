import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import '../../../model/accounting/invoices/InvoicesModel.dart';
class DbInvoices {
  DbHelper dbHelper = DbHelper();

  Future<List<InvoicesModel>> allInvioces() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from invoices where invoice_class="المبيعات"';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => InvoicesModel.fromMap(e)).toList();
  }
  Future<List<InvoicesModel>> expenseInvioces() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from invoices where invoice_class="المشتريات"';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => InvoicesModel.fromMap(e)).toList();
  }

  Future <InvoicesModel> FindInvioce(String id) async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from invoices WHERE invoice_id=$id ';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return InvoicesModel.fromMap(queryResult.first) ;
  }
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

  addInvoices(InvoicesModel InvoicesModel ) async {
    Database? db = await dbHelper.openDb();
    db!.insert("invoices", InvoicesModel.toMap());
  }
  Future<void> addInvoices2(
      String _rate ,
      String _date,
      String _time,
      String _account_no ,
      String _account_name ,
      String _accountingTo_no ,
      String _accountingTo_name ,
      String _amount,
      String _disscount,
      String _amount_all,
      String _currency ,
      String _payment,
      String _payment_currency ,
      String _remaining ,
      String _jornal ,
      String _discription ,
      String _type
      ) async {
    String Sql='INSERT INTO invoices (invoice_rate, invoice_date, invoice_time, invoice_account_no, invoice_account_name, invoice_accountingTo_no, invoice_accountingTo_name, invoice_amount, invoice_disscount, invoice_amount_all, invoice_currency, invoice_payment, invoice_payment_currency, invoice_remaining, invoice_jornal, invoice_discription, invoice_class) VALUES ';
    Sql=Sql+'("$_rate","$_date","$_time","$_account_no","$_account_name","$_accountingTo_no", "$_accountingTo_name","$_amount","$_disscount","$_amount_all","$_currency","$_payment","$_payment_currency","$_remaining","$_jornal","","$_type");';
    Database? db = await dbHelper.openDb();
    return db!.execute(Sql) ;
  }
  updateInvoices(
      String _id ,
      String _rate ,
      String _date,
      String _time,
      String _account_no ,
      String _account_name ,
      String _accountingTo_no ,
      String _accountingTo_name ,
      String _amount,
      String _disscount,
      String _amount_all,
      String _currency ,
      String _payment,
      String _payment_currency ,
      String _remaining ,
      String _jornal ,
      String _discription ,
      String _type
      ) async {
    Database? db = await dbHelper.openDb();
    String sql ='UPDATE invoices SET invoice_rate="$_rate",invoice_date="$_date",invoice_time="$_time",invoice_account_no="$_account_no",invoice_account_name="$_account_name"';
    sql=sql+' ,invoice_accountingTo_no="$_accountingTo_no" ,invoice_accountingTo_name="$_accountingTo_name" ,invoice_amount="$_amount" ,invoice_disscount="$_disscount" ';
    sql=sql+' ,invoice_amount_all="$_amount_all" ,invoice_currency="$_currency" ,invoice_payment="$_payment" ,invoice_payment_currency="$_payment_currency"  ,invoice_remaining="$_remaining" ';
    sql=sql+' ,invoice_jornal="$_jornal"  ,invoice_discription="$_discription"  ,invoice_class="$_type"  WHERE invoice_id="$_id"';
    db!.rawQuery(sql);
  }

}
