import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:hussam_clinc/model/accounting/AccoutingTreeModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DbTree {
  DbHelper dbHelper = DbHelper();

  Future<List<AccoutingTreeModel>> allAccountingTree() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from accounting_tree';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => AccoutingTreeModel.fromMap(e)).toList();
  }

  Future<List<AccoutingTreeModel>> allAccountingTreeGrouping() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from accounting_tree GROUP BY accounting_tree.AT_father_no';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => AccoutingTreeModel.fromMap(e)).toList();
  }

  //GROUP BY date_doctorId,date_place,date(dates.date_dateStart),period
  Future<List<AccoutingTreeModel>> allEmployeeAccounting() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from all_Employee_Acounting';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => AccoutingTreeModel.fromMap(e)).toList();
  }

  Future<List<AccoutingTreeModel>> allPaitentsAccounting() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from all_Paitents_Acounting';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => AccoutingTreeModel.fromMap(e)).toList();
  }

  Future<List<AccoutingTreeModel>> allSuppliersAccounting() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT * from all_Suppliers_Acounting';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => AccoutingTreeModel.fromMap(e)).toList();
  }

}
