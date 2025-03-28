import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:hussam_clinc/model/accounting/invoices/InvoicesDetailModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DbInvoicesDetails {
  DbHelper dbHelper = DbHelper();

  // CREATE TABLE "invoices_detail" (
  // "ID_id"	INTEGER NOT NULL UNIQUE,
  // "ID_invoices_id"	TEXT DEFAULT 'رقم الفاتورة',
  // "ID_item_no"	TEXT DEFAULT 'رقم الصنف',
  // "ID_item_name"	TEXT DEFAULT 'اسم الصنف',
  // "ID_unit_name"	TEXT DEFAULT 'الوحدة',
  // "ID_unit_qty"	TEXT DEFAULT 'الكمية',
  // "ID_unit_price"	TEXT DEFAULT 'سعر الوحدة',
  // "ID_net_price"	TEXT DEFAULT 'الإجمالي',
  // PRIMARY KEY("ID_id" AUTOINCREMENT)
  // );

  addInvoicesDetails(InvoicesDetailModel invoicesDetailModel ) async {
    Database? db = await dbHelper.openDb();
    db!.insert("invoices_detail", invoicesDetailModel.toMap());
  }

  Future<List<InvoicesDetailModel>> searchInvoicesDetails(String id) async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from invoices_detail WHERE ID_invoices_id=$id ';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => InvoicesDetailModel.fromMap(e)).toList();
  }


  Future<void> addInvoicesDetails2(
      String _invoices_id ,
      String _item_no,
      String _item_name,
      String _unit_name ,
      String _unit_qty ,
      String _unit_price ,
      String _net_price
      ) async {
    String Sql='INSERT INTO invoices_detail (ID_invoices_id, ID_item_no, ID_item_name, ID_unit_name, ID_unit_qty, ID_unit_price, ID_net_price)  VALUES ';
    Sql=Sql+'("$_invoices_id","$_item_no","$_item_name","$_unit_name","$_unit_qty","$_unit_price","$_net_price");';
    Database? db = await dbHelper.openDb();
    return db!.execute(Sql) ;
  }

  Future<void> UpdateInvoicesDetails(
      String _id ,
      String _invoices_id ,
      String _item_no,
      String _item_name,
      String _unit_name ,
      String _unit_qty ,
      String _unit_price ,
      String _net_price
      ) async {
    String Sql ='UPDATE invoices_detail SET ID_invoices_id="$_invoices_id",ID_item_no="$_item_no",ID_item_name="$_item_name" ';
    Sql='$Sql ,ID_unit_name="وحدة" ,ID_unit_qty="$_unit_qty" ,ID_unit_price="$_unit_price" ,ID_net_price="$_net_price" ';
    Sql='$Sql    WHERE ID_id="$_id"';

    Database? db = await dbHelper.openDb();
    return db!.execute(Sql) ;
  }
}
