import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import '../model/Employment/EmployeeModel.dart';



class DbEmployee {
  DbHelper dbHelper = DbHelper();
  Future<List<Map<String, Object?>>> allEmployees() async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from employees ORDER by employee_name ASC';
    return db!.rawQuery(sql);
  }

  Future<List<EmployeeModel>> allEmployeesModel() async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from employees ORDER by employee_name ASC';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => EmployeeModel.fromMap(e)).toList();
  }


  Future<List<EmployeeModel>> allEmployeesM() async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from employees ORDER by employee_name ASC';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => EmployeeModel.fromMap(e)).toList();
  }

  Future<List<Map<String, Object?>>> searchEmployeeById(int id) async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from  employees WHERE employee_id=$id ORDER by employee_name ASC';
    return db!.rawQuery(sql);
  }

  deleteEmployee(int id) async {
    Database? db = await dbHelper.openDb();
    // return db!.delete('persons', where: 'id = ?', whereArgs: [id]);
    String sql = 'DELETE FROM employees  WHERE employee_id=$id';
    db!.rawQuery(sql);
  }

  Future<Future<List<Map<String, Object?>>>?> searchingEmployee(
      String name) async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    if (name.isNotEmpty) {
      sql =
          'SELECT * from  employees	 WHERE employee_name like "$name%"  or employee_name like "%$name"  or employee_name like "%$name%" ORDER by employee_name ASC';
    } else {
      sql = 'SELECT * from  employees ORDER by employee_name ASC';
    }
    return db?.rawQuery(sql);
  }
// CREATE TABLE "employees" (
// "employee_id"	INTEGER NOT NULL UNIQUE,
// "employee_name"	TEXT,
// "employee_mobile"	TEXT,
// "employee_jop"	TEXT,

  Future<void> addEmployee(String name, String mobile,String jop) async {
    Database? db = await dbHelper.openDb();
    return db!.execute(
        'INSERT INTO employees (employee_name, employee_mobile, employee_jop) VALUES ("$name", "$mobile", "$jop");');
  }
}
