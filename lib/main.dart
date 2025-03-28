import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hussam_clinc/View_model/ViewModelGlobal.dart';
import 'package:hussam_clinc/data/TimetableWidgt.dart';
import 'package:hussam_clinc/global_var/globals.dart';
import 'package:hussam_clinc/model/Employment/EmployeeModel.dart';
import 'package:hussam_clinc/model/accounting/AccoutingTreeModel.dart';
import 'package:hussam_clinc/model/accounting/invoices/InvoicesModel.dart';
import 'package:hussam_clinc/model/accounting/journals/IndexModel.dart';
import 'package:hussam_clinc/model/accounting/journals/journalsModel.dart';
import 'package:hussam_clinc/pages/accounting/invoices/SalesInvoices.dart';
import 'package:hussam_clinc/pages/accounting/invoices/expenseInvoices.dart';
import 'package:hussam_clinc/pages/accounting/invoices/expenseInvoicesReview.dart';
import 'package:hussam_clinc/pages/accounting/invoices/saleInvoicesReview.dart';
import 'package:hussam_clinc/pages/accounting/journals/journalsReview.dart';
import 'package:hussam_clinc/pages/costumer/PageCostumers.dart';
import 'package:timetable/timetable.dart';
import 'model/DatesModel.dart';
import 'model/patients/PatientModel.dart';

List<DateTime> DatesListUniq=[];
List<DateModel> DatesList=[];
List<DateModel> allDatesList=[];
/// Accounting Data
List<AccoutingTreeModel> allAccountingTree=[];
List<String> allAccountingTreeGroup=[];
List<IndexModel> allAccountingIndex=[];
List<String> allAccountingIndex_s=[];

List<AccoutingTreeModel> allAccountingCoustmers=[];
List<String> allAccountingCoustmers_s=[];

List<AccoutingTreeModel> allAccountingSuppliers=[];
List<String> allAccountingSuppliers_s=[];

List<AccoutingTreeModel> allAccountingEmployees=[];
List<String> allAccountingEmployees_s=[];

List<String> allAccountingContens=[];
String AccountingIndx_select_id='o';
IndexModel AccountingIndexModel=IndexModel.name();

List<PatientModel> allPatient = [];
List<EmployeeModel> allEmployees = [];
List<InvoicesModel> allInvoices = [];
List<InvoicesModel> expenseInvoices = [];
List<JournalsModel> allJournals = [];

String maxNoPic='1';
String MaxFiledNo='1';

String selected_event_id='';
DateModel selected_event_Model=_DateModel.empty();
var VMGlobal = ViewModelGlobal();
class _DateModel extends DateModel  {
  _DateModel.empty()
      : super({
    "date_id":0,
    "date_kind":'مواعيد المرضى',
    "date_place":"غرفة 1",
    "date_dateStart": DateTime.now().isAtStartOfDay.toString(),
    "date_dateEnd":DateTime.now().isAtStartOfDay.toString(),
    "date_note":'',
    "date_doctorId":'',
    "date_doctorName":'',
    "date_costumerId":'',
    "date_costumerName":'',
  });

}
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D9D99)),
        useMaterial3: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: const TimetableWidgt( title: 'الصفحة الرئيسية ' ),
    );
  }
}
@override
Widget drawing(BuildContext context) {
  return Drawer(
    shadowColor:Colors.blue,
    elevation: 10.0,
    child: ListView(children: [
      const SizedBox(height: 30),
      CircleAvatar(
        backgroundColor:Colors.black,
        radius: 90,
        child:Image.asset('assets/images/logo.png',
            width: 180,
            height:180),
      ),
      const SizedBox(height: 20),
      ListTile(
        title: const Text(
          'المرضى',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        leading: Image.asset(
          "assets/icon/patients.png",
          width: 45,
          height: 45,
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  PageCostumers(allPatient)));
        },
      ),
      const SizedBox(
        height: 10,),
      ListTile(
        title: const Text(
          'الموظفين',
          style: TextStyle(
            fontSize: 25,
            color: Colors.blue,
          ),
        ),
        leading: SizedBox(
          height: 80,
          child:  Image.asset(
            "assets/icon/doctor.png",
            width: 50,
            height: 50,
          ),
        ),
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const IncomePage()));
        },
      ),
      const SizedBox(
        height: 5,),

      ListTile(
        title: const Text(
          'الموردين',
          style: TextStyle(
            fontSize: 25,
            color: Colors.blue,
          ),
        ),
        leading: SizedBox(
          height: 80,
          child:  Image.asset(
            "assets/icon/supliers.png",
            width: 50,
            height: 50,
          ),
        ),
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const IncomePage()));
        },
      ),
      const SizedBox(
        height: 5,),
      ExpansionTile(
        initiallyExpanded:true,
        collapsedIconColor:Colors.pink,
        leading: SizedBox(
          height: 60,
          child: Image.asset(
            "assets/accounting/accounting.png",
            width: 45,
            height: 45,
          ),
        ),
        title:const Text (
          "المالية",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        children: [
          ExpansionTile(
            collapsedIconColor:Colors.pink,
            leading: SizedBox(
              height: 60,
              child: Image.asset(
                "assets/accounting/invoices.png",
                width: 45,
                height: 45,
              ),
            ),
            title:const Text (
              "الفواتير",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            children: [
              ListTile(
                title: const Text(
                  'فاتورة المبيعات',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.blue,
                  ),
                ),
                leading: SizedBox(
                  height: 60,
                  child: Image.asset(
                    "assets/accounting/expense_invoice.png",
                    width: 45,
                    height: 45,
                  ),
                ),
                onTap: () {
                  AllEmplyess();
                  VMGlobal.MaxNoS();
                  Navigator.of(context) .push(MaterialPageRoute(builder: (context) => const SalesInvoices()));
                },
              ),
              const SizedBox(
                height: 5,),
              ListTile(
                title: const Text(
                  ' مراجعة فواتير المبيعات',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.blue,
                  ),
                ),
                leading: SizedBox(
                  height: 60,
                  child: Image.asset(
                    "assets/accounting/expense_invoice_reviwe.png",
                    width: 45,
                    height: 45,
                  ),
                ),
                onTap: () async {
                  AllInvioces();
                  await Future.delayed(const Duration(milliseconds: 500));
                  //initializeDateFormatting('en_US', null).then((_) =>
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SaleInvoicesReview()));
                  //);
                },
              ),
              const SizedBox(
                height: 5,),
              ListTile(
                title: const Text(
                  'فاتورة مشتريات',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.blue,
                  ),
                ),
                leading: SizedBox(
                  height: 60,
                  child: Image.asset(
                    "assets/accounting/sales_invoice.png",
                    width: 45,
                    height: 45,
                  ),
                ),
                onTap: () async {
                  AllEmplyess();
                  VMGlobal.MaxNoS();
                  await Future.delayed(const Duration(milliseconds: 500));
                  Navigator.of(context) .push(MaterialPageRoute(builder: (context) => const ExpenseInvoices()));
                },
              ),
              const SizedBox(
                height: 5,),
              ListTile(
                title: const Text(
                  ' مراجعة فواتير المشتريات',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.blue,
                  ),
                ),
                leading: SizedBox(
                  height: 60,
                  child: Image.asset(
                    "assets/accounting/sales_invoice_reviwe.png",
                    width: 45,
                    height: 45,
                  ),
                ),
                onTap: ()async {
                  ExpenseInvioces();
                  await Future.delayed(const Duration(milliseconds: 500));
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExpenseInvoicesReview()));
                  // AllEmplyess();
                  // MaxNoS();
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SalesInvoices()));
                },
              ),

            ],
          ),
          ExpansionTile(
            title:const Text (
              "الإيصالات",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            collapsedIconColor:Colors.pink,
            leading: SizedBox(
              height: 60,
              child: Image.asset(
                "assets/accounting/vouchers.png",
                width: 45,
                height: 45,
              ),
            ),

            children: [
              ListTile(
                title: const Text(
                  'إيصال قبض',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.blue,
                  ),
                ),
                leading: SizedBox(
                  height: 60,
                  child: Image.asset(
                    "assets/accounting/reciept_voucher.png",
                    width: 45,
                    height: 45,
                  ),
                ),
                onTap: () {
                  // Navigator.of(context) .push(MaterialPageRoute(builder: (context) => const SalesInvoices()));
                },
              ),
              const SizedBox(
                height: 5,),

              ListTile(
                title: const Text(
                  ' مراجعة إيصال القبض ',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.blue,
                  ),
                ),
                leading: SizedBox(
                  height: 60,
                  child: Image.asset(
                    "assets/accounting/reciept_voucher_reviwe.png",
                    width: 45,
                    height: 45,
                  ),
                ),
                onTap: () {
                  // AllEmplyess();
                  // MaxNoS();
                  // Navigator.of(context) .push(MaterialPageRoute(builder: (context) => const SalesInvoices()));
                },
              ),
              const SizedBox(
                height: 5,),
              ListTile(
                title: const Text(
                  'إيصال صرف',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.blue,
                  ),
                ),
                leading: SizedBox(
                  height: 60,
                  child: Image.asset(
                    "assets/accounting/payment_voucher.png",
                    width: 45,
                    height: 45,
                  ),
                ),
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InvoicesPage()));
                },
              ),
              ListTile(
                title: const Text(
                  ' مراجعة إيصال الصرف ',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.blue,
                  ),
                ),
                leading: SizedBox(
                  height: 60,
                  child: Image.asset(
                    "assets/accounting/payment_voucher_reviwe.png",
                    width: 45,
                    height: 45,
                  ),
                ),
                onTap: () {
                  // AllEmplyess();
                  // MaxNoS();
                  // Navigator.of(context) .push(MaterialPageRoute(builder: (context) => const SalesInvoices()));
                },
              ),
              const SizedBox(
                height: 5,),
            ],
          ),
          ListTile(
            title: const Text(
              'القيود',
              style: TextStyle(
                fontSize: 23,
                color: Colors.blue,
              ),
            ),
            leading: SizedBox(
              height: 60,
              child: Image.asset(
                "assets/accounting/journal.png",
                width: 45,
                height: 45,
              ),
            ),
            onTap: () async {
              Journals();
              await Future.delayed(const Duration(milliseconds: 500));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const JournalsReview()));
            },
          ),
          ListTile(
            title: const Text(
              'حركة الحساب',
              style: TextStyle(
                fontSize: 23,
                color: Colors.blue,
              ),
            ),
            leading: SizedBox(
              height: 60,
              child: Image.asset(
                "assets/accounting/calculation.png",
                width: 45,
                height: 45,
              ),
            ),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InvoicesPage()));
            },
          ),
          ListTile(
            title: const Text(
              ' شجرة الحسابات',
              style: TextStyle(
                fontSize: 23,
                color: Colors.blue,
              ),
            ),
            leading: SizedBox(
              height: 60,
              child: Image.asset(
                "assets/accounting/tree.png",
                width: 45,
                height: 45,
              ),
            ),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InvoicesPage()));
            },
          ),
        ],
      ),
    ]),
  );
}
