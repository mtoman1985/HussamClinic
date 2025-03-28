import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:hussam_clinc/model/patients/PatientHealthDoctorModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DbPatientHealthDoctor {
  DbHelper dbHelper = DbHelper();

  Future<List<PatienHealthtDoctorModel>> allPHDs() async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from patient_health_doctor ORDER by PHD_date ASC';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => PatienHealthtDoctorModel.fromMap(e)).toList();
  }

  Future<List<PatienHealthtDoctorModel>> searchByPatientId(int id) async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from  patient_health_doctor WHERE PHD_patientId=$id ORDER by PHD_date ASC';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => PatienHealthtDoctorModel.fromMap(e)).toList();
  }

  deletePHD(int id) async {
    Database? db = await dbHelper.openDb();
    String sql = 'DELETE FROM patient_health_doctor  WHERE PHD_id=$id';
    db!.rawQuery(sql);
  }

  updatePHD(int id,PatienHealthtDoctorModel PHD ) async {
    Database? db = await dbHelper.openDb();
    db!.update ("patient_health_doctor", PHD.toMap(),
        where: 'PHD_id = ?', whereArgs: [id]);
  }

  // CREATE TABLE "patient_health_doctor" (
  // "PHD_id"	INTEGER NOT NULL UNIQUE,
  // "PHD_patientId"	INTEGER,
  // "PHD_doctorId"	INTEGER,
  // "PHD_doctorName"	TEXT,
  // "PHD_date"	TEXT,
  // "PHD_treatment"	TEXT,
  // "PHD_diagnosis"	TEXT,
  // PRIMARY KEY("PHD_id" AUTOINCREMENT)
  // );
  Future<void> addPHD(
      String PHD_patientId,String PHD_doctorId,
      String PHD_doctorName, String PHD_date,
      String PHD_treatment, String PHD_diagnosis
      ) async {
    Database? db = await dbHelper.openDb();
    return db!.execute(
        'INSERT INTO patient_health_doctor (PHD_patientId, PHD_doctorId, PHD_doctorName, PHD_date, PHD_treatment, PHD_diagnosis) VALUES ("$PHD_patientId", "$PHD_doctorId","$PHD_doctorName", "$PHD_date","$PHD_treatment", "$PHD_diagnosis");');
  }
}
