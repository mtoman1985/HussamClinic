library globals;
import 'dart:io';
import 'package:hussam_clinc/db/accounting/dbindex.dart';
import 'package:hussam_clinc/db/accounting/journal/dbjournaldetails.dart';
import 'package:hussam_clinc/db/accounting/dbtree.dart';
import 'package:hussam_clinc/db/accounting/journal/dbjournals.dart';
import 'package:hussam_clinc/db/dbemployee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../db/accounting/invoices/dbinvoices.dart';
import '../db/patients/dbpatient.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

Future<void> savePDFFile(List<int> bytes, String fileName) async {
  final path = (await getExternalStorageDirectory())?.path;
  final file = File('$extFilesReports/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$path/$fileName');
}

final Map<int, Color> colorMapper = {
  0: Colors.green,
  1: Colors.blue,
  2: Colors.blueGrey[600]!,
  3: Colors.grey,
  4: Colors.blueGrey[50]!,
  5: Colors.blueGrey[400]!,
  6: Colors.blueGrey[500]!,
  7: Colors.blueGrey[600]!,
  8: Colors.blueGrey[700]!,
  9: Colors.green,
  10: Colors.green,
};

extension ColorUtil on Color {
  Color byLuminance() =>
      this.computeLuminance() > 0.4 ? Colors.black87 : Colors.white;
}


Future<void> AllPatientList() async {
  allPatient.clear();
  DbPatient dbPatient = DbPatient();
  dbPatient.allPatients().then((Patients) {
    for (var patient in Patients) {
      allPatient.add(patient);
    }
  });
}


Future<void> AllAccountingTreeList() async {
  allAccountingTree.clear();
  DbTree dbTree = DbTree();
  dbTree.allAccountingTree().then((trees) {
    for (var tree in trees) {
      allAccountingTree.add(tree);
    }
  });
  }

  Future<void> AllAccountingTreeGroup() async {
    allAccountingTreeGroup.clear();
  DbTree dbTree = DbTree();
  dbTree.allAccountingTreeGrouping().then((trees) {
    for (var tree in trees) {
      allAccountingTreeGroup.add(tree.father_no);
    }
  });
}

Future<void> AllAccountingIndexList() async {
  allAccountingIndex.clear();
  allAccountingIndex_s.clear();
  DbIndex dbIndex = DbIndex();
  dbIndex.allAccountingIndexes().then((inedxes) {
    for (var index in inedxes) {
      allAccountingIndex.add(index);
      allAccountingIndex_s.add(index.name);
    }
  });
}
Future<void> AllEmployeeTreeList() async {
  allAccountingEmployees.clear();
  allAccountingEmployees_s.clear();
  DbTree dbTree = DbTree();
  dbTree.allEmployeeAccounting().then((trees) {
    for (var tree in trees) {
      allAccountingEmployees.add(tree);
      allAccountingEmployees_s.add(tree.name.toString());
    }
  });
}
Future<void> AllPaitentsTreeList() async {
  allAccountingCoustmers.clear();
  allAccountingCoustmers_s.clear();
  DbTree dbTree = DbTree();
  dbTree.allPaitentsAccounting().then((trees) {
    for (var tree in trees) {
      allAccountingCoustmers.add(tree);
      allAccountingCoustmers_s.add(tree.name.toString());
    }
  });
}
Future<void> AllSuppliersTreeList() async {
  allAccountingSuppliers.clear();
  allAccountingSuppliers_s.clear();
  DbTree dbTree = DbTree();
  dbTree.allSuppliersAccounting().then((trees) {
    for (var tree in trees) {
      allAccountingSuppliers.add(tree);
      allAccountingSuppliers_s.add(tree.name.toString());
    }
  });
}


Future<void> AllEmplyess() async {
  allPatient.clear();
  DbEmployee dbEmployee = DbEmployee();
  dbEmployee.allEmployeesModel().then((Employees) {
    for (var employee in Employees) {
      allEmployees.add(employee);
    }
  });
}

Future<void> AllInvioces() async {
  allInvoices.clear();
  DbInvoices dbInvoices = DbInvoices();
  dbInvoices.allInvioces().then((Invoices) {
    for (var Invoice in Invoices) {
      allInvoices.add(Invoice);
    }
  });
}

Future<void> ExpenseInvioces() async {
  expenseInvoices.clear();
  DbInvoices dbInvoices = DbInvoices();
  dbInvoices.expenseInvioces().then((Invoices) {
    for (var Invoice in Invoices) {
      expenseInvoices.add(Invoice);
    }
  });
}
Future<void> Journals() async {
  allJournals.clear();
  DbJournals  dbJournals = DbJournals();
  dbJournals.allJournals().then((journals) {
    for (var journal in journals) {
      allJournals.add(journal);
    }
  });
}

const extFolder = "/storage/emulated/0/HussamClinc";
const extDbFolder = "/storage/emulated/0/HussamClinc/db";
const extPicFolder = "/storage/emulated/0/HussamClinc/pic";
const extFilesFolder = "/storage/emulated/0/HussamClinc/files";
const extFilesReports = "/storage/emulated/0/HussamClinc/reports";

void copyExternalDB() async {
  const dbFolder = "/data/user/0/com.hussam.hussam_clinc/databases";
  File source1 = File('$dbFolder/db.db');
  String FileName='db';
  DateTime TodayNow=DateTime.now();

  if (TodayNow.day%8==0){
    FileName = 'Remain_00';
  }else if (TodayNow.day%8==1){
    FileName = 'Remain_01';
  }else if (TodayNow.day%8==2){
    FileName = 'Remain_02';
  }else if (TodayNow.day%8==3){
    FileName = 'Remain_03';
  }else if (TodayNow.day%8==4){
    FileName = 'Remain_04';
  }else if (TodayNow.day%8==5){
    FileName = 'Remain_05';
  }else if (TodayNow.day%8==6){
    FileName = 'Remain_06';
  }else if (TodayNow.day%8==7){
    FileName = 'Remain_07';
  }else {
    FileName='Remain_08';
  }

  if (TodayNow.hour>=9 && TodayNow.hour<10) {
    FileName ='${FileName}_Time01';
  } else if (TodayNow.hour<=10) {
    FileName ='${FileName}_Time02';
  }else if (TodayNow.hour<=11) {
    FileName ='${FileName}_Time03';
  }else if (TodayNow.hour<=13) {
    FileName = '${FileName}_Time04';
  }else if (TodayNow.hour<=15) {
    FileName = '${FileName}Time05';
  }else if (TodayNow.hour<=17) {
    FileName = '${FileName}_Time06';
  }else if (TodayNow.hour<=18) {
    FileName = '${FileName}_Time07';
  }else if (TodayNow.hour<=19) {
    FileName = '${FileName}_Time08';
  }else if (TodayNow.hour<=20) {
    FileName = '${FileName}_Time09';
  }else if (TodayNow.hour<=21) {
    FileName = '${FileName}_Time10';
  }
  else {
    FileName='${FileName}_Time11';
  }

  File copyTo = File('/storage/emulated/0/HussamClinc/db/$FileName.db');
  List<int>  content = await source1.readAsBytes();
  PermissionStatus status2 = await Permission.manageExternalStorage.request();
  if ( status2.isGranted) {
    await copyTo.writeAsBytes(content, flush: true);
  }
}
void creatExtFolder(String folderName) async {
  creatExtMainFolder();
  Directory path = Directory("$extFolder/$folderName");
  if ((await path.exists())) {
    print("exists file ");
  } else {
    PermissionStatus status2 = await Permission.manageExternalStorage.request();
    if ( status2.isGranted) {
      path.createSync();
    }
  }
}

void creatExtMainFolder() async {
  Directory path = Directory(extFolder);
  if ((await path.exists())) {
    print("exists file ");
  } else {
    PermissionStatus status2 = await Permission.manageExternalStorage.request();
    if ( status2.isGranted) {
      path.createSync();
    }
  }

}
