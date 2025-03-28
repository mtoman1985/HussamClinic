import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:hussam_clinc/main.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import '../../model/patients/PatientModel.dart';

class DbPatient {
  DbHelper dbHelper = DbHelper();

  Future<List<PatientModel>> allPatients() async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from patients ORDER by patient_Name';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => PatientModel.fromMap(e)).toList();
  }
  // Future<List<DateModel>> alldate() async {
  //   Database? db = await dbHelper.openDb();
  //   String sql = 'SELECT * from dates ORDER by date_id ASC';
  //   final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
  //   return queryResult.map((e) => DateModel.fromMap(e)).toList();
  // }

  Future<List<Map<String, Object?>>> searchPatientById(int id) async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from  patients WHERE patient_id=$id ORDER by patient_name ASC';
    return db!.rawQuery(sql);
  }

  deletePatient(int id) async {
    Database? db = await dbHelper.openDb();
    String sql = 'DELETE FROM patients  WHERE patient_id=$id';
    db!.rawQuery(sql);
  }

  updatePatient(int id,PatientModel patint ) async {
    Database? db = await dbHelper.openDb();
    // String sql = 'DELETE FROM patients  WHERE patient_id=$id';
    // db!.rawQuery(sql);
    db!.update ("patients", patint.toMap(),
        where: 'patient_id = ?', whereArgs: [id]);
  }

  updateFileNoPatient(
      String name, String mobile,
      String sex,    String status,
      String birthDay,  String fileNo,
      String Address,  String resone ,  String worries
      ) async {
    Database? db = await dbHelper.openDb();
    String sql ='UPDATE patients SET patient_Name="$name",patient_mobile="$mobile",patient_sex="$sex",patient_status="$status",patient_birthDay="$birthDay" ,patient_Address="$Address",patient_resone="$resone",patient_worries="$worries" WHERE patient_fileNo="$fileNo"';
    db!.rawQuery(sql);
  }

  Future<Future<List<Map<String, Object?>>>?> searchingPatient(
      String name) async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    if (name.isNotEmpty) {
      sql =
          'SELECT * from  patients WHERE patient_name like "$name%"  or patient_name like "%$name"  or patient_name like "%$name%" ORDER by patient_name ASC';
    } else {
      sql = 'SELECT * from  patients ORDER by patient_name ASC';
    }
    return db?.rawQuery(sql);
  }

  Future<void> MaxFileNo() async {
    Database? db = await dbHelper.openDb();
    String sql = "";
    sql = 'SELECT max(patients.patient_fileNo) as d from patients';
    final List<Map<String, Object?>> queryResult = await db!.rawQuery(sql);
    MaxFiledNo =queryResult.elementAt(0).values.elementAt(0).toString();
    MaxFiledNo=( int.parse(MaxFiledNo)+1).toString();
   }
  // "patient_id"	INTEGER NOT NULL UNIQUE,
  // "patient_Name"	TEXT,    // "patient_mobile"	TEXT,
  // "patient_sex"	TEXT,    // "patient_status"	TEXT,
  // "patient_birthDay"	TEXT,    // "patient_age"	INTEGER,
  // "patient_fileNo"	INTEGER UNIQUE,    // "patient_Address"	TEXT,
  // "patient_resone"	TEXT,  // "patient_worries"	TEXT,
  Future<void> addPatient(String name, String mobile,
      String sex,    String status,
      String birthDay,  String fileNo,
      String Address,  String resone ,  String worries) async {
    Database? db = await dbHelper.openDb();
    return db!.execute(
        'INSERT INTO patients (patient_Name, patient_mobile, patient_sex, patient_status, patient_birthDay, patient_fileNo, patient_Address, patient_resone, patient_worries ) VALUES ("$name", "$mobile","$sex", "$status","$birthDay", "$fileNo","$Address", "$resone", "$worries");');
  }
}
