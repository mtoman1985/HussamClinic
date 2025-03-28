import 'package:hussam_clinc/db/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../../model/patients/PatientHealthModel.dart';

class DbPatientHealth {
  DbHelper dbHelper = DbHelper();

  Future<List<PatienHealthtModel>> allPHs() async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from patient_health ORDER by PH_patientId ASC';
    final List<Map<String, Object?>> queryResult = await  db!.rawQuery(sql);
    return queryResult.map((e) => PatienHealthtModel.fromMap(e)).toList();
  }

  Future<List<Map<String, Object?>>> searchPatientById(int id) async {
    Database? db = await dbHelper.openDb();
    String sql = 'SELECT * from  patients WHERE patient_id=$id ORDER by patient_name ASC';
    return db!.rawQuery(sql);
  }

  deletePatient(int id) async {
    Database? db = await dbHelper.openDb();
    String sql = 'DELETE FROM patient_health  WHERE patient_id=$id';
    db!.rawQuery(sql);
  }

  updatePatientHealth(int id,PatienHealthtModel PH ) async {
    Database? db = await dbHelper.openDb();
    db!.update ("patient_health", PH.toMap(),
        where: 'patient_id = ?', whereArgs: [id]);
    }

  // CREATE TABLE "patient_health" (
  // "PH_id"	INTEGER,
  // "PH_patientId"	INTEGER UNIQUE,  // "PH"	TEXT,  //
  // "PH_sensitive"	TEXT,  // "PH_sensitive_Ex"	TEXT,
  // "PH_surgical"	TEXT,  // "PH_surgical_Ex"	TEXT,
  // "PH_haemophilia"	TEXT,  // "PH_haemophilia_Ex"	TEXT,
  // "PH_drugs"	TEXT,  // "PH_drugs_Ex"	TEXT,
  // "PH_oralDiseases"	TEXT,  // "PH_smoking"	TEXT,
  // "PH_pregnant"	TEXT,  // "PH_pregnant_Ex"	INTEGER,
  // "PH_lactating"	TEXT,  // "PH_lactating_Ex"	INTEGER,
  // "PH_contraception"	TEXT,  // "PH_contraception_Ex"	TEXT,
  // PRIMARY KEY("PH_id","PH_patientId")
  // );
  Future<void> addPatientHealth(
      String PH_patientId, String PH,
      String PH_sensitive, String PH_sensitive_Ex,
      String PH_surgical, String PH_surgical_Ex,
      String PH_haemophilia, String PH_haemophilia_Ex ,
      String PH_oralDiseases, String PH_smoking ,
      String PH_pregnant, String PH_pregnant_Ex ,
      String PH_lactating, String PH_lactating_Ex ,
      String PH_contraception, String PH_contraception_Ex ,
      ) async {
    Database? db = await dbHelper.openDb();
    return db!.execute(
        'INSERT INTO patient_health (PH_patientId, PH, PH_sensitive, PH_sensitive_Ex, PH_surgical, PH_surgical_Ex, PH_haemophilia, PH_haemophilia_Ex, PH_oralDiseases, PH_smoking, PH_pregnant ,PH_pregnant_Ex, PH_lactating, PH_lactating_Ex, PH_contraception, PH_contraception_Ex ) VALUES ("$PH_patientId", "$PH","$PH_sensitive", "$PH_sensitive_Ex","$PH_surgical", "$PH_surgical_Ex","$PH_haemophilia", "$PH_haemophilia_Ex","$PH_oralDiseases", "$PH_smoking","$PH_pregnant","$PH_pregnant_Ex","$PH_lactating", "$PH_lactating_Ex", "$PH_contraception", "$PH_contraception_Ex");');
  }
}
