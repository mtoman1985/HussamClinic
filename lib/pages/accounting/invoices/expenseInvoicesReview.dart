import 'package:flutter/material.dart';
import 'package:hussam_clinc/datasource/expenseReview_datasource.dart';
import 'package:hussam_clinc/pages/accounting/invoices/expenseInvoices.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../global_var/globals.dart';
import '../../../main.dart';
import 'SalesInvoices.dart';

const Color primaryColor = Color(0xffd0d4d7); //corner
const Color accentColor = Color(0xff3f86bd); //background
const TextStyle textStyle = TextStyle(color:  Color(0xff7bb05d),fontSize: 14);
const TextStyle textStyleSubItems = TextStyle(color: Colors.grey);

class ExpenseInvoicesReview extends StatefulWidget{
  const ExpenseInvoicesReview({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ExpenseInvoicesReviewState();
  }
}

class ExpenseInvoicesReviewState extends State<ExpenseInvoicesReview> {
  late ExpenseReviewDataSource expenseReviewData;
  final DataGridController _dataGridController = DataGridController();

  @override
  void initState() {
    super.initState();
    setState(() {
      //AllInvioces();
      expenseReviewData = ExpenseReviewDataSource(expenseinvoicesData:expenseInvoices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1D9D99),
            title: const Text(
              'فواتير المشتريات',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          body:
          SfDataGridTheme(
            data: SfDataGridThemeData(headerColor: const Color(0xff009889)),
            child: datatable(),
          ),
        ),
      );
  }

  SfDataGrid datatable() {
    return SfDataGrid(
      selectionMode: SelectionMode.single,
      frozenColumnsCount: 1,
      allowColumnsResizing:true,
      allowFiltering: true,
      navigationMode: GridNavigationMode.cell,
      columnWidthMode: ColumnWidthMode.auto,
      rowsPerPage: 30,
      editingGestureType: EditingGestureType.tap,
      controller: _dataGridController,
      onCellTap: (DataGridCellTapDetails details) {
        if (details.rowColumnIndex.rowIndex >= 1 ||
            details.rowColumnIndex.rowIndex <= allEmployees.length ) {
          setState(() {
            String s= expenseReviewData
                .effectiveRows[details.rowColumnIndex.rowIndex-1 ]
                .getCells()[0]
                .value
                .toString();
            VMExpenseInvoice.EditeAlreadyInvoices(s);
            VMExpenseInvoice.MaxInvoices=s;
            String sm= expenseReviewData
                .effectiveRows[details.rowColumnIndex.rowIndex-1 ]
                .getCells()[5]
                .value
                .toString();
            VMExpenseInvoice.Maxjournals=sm;
            AllEmplyess();
          });
          Future.delayed(const Duration(seconds: 1)).then((value) {
            Navigator.of(context) .push(MaterialPageRoute(builder: (context) =>  const  ExpenseInvoices()));
          });
        }
      },
      allowSorting: true,
      source: expenseReviewData,
      columns: Columns(),
    );
  }

  List<GridColumn> Columns(){
    return <GridColumn>[
      GridColumn(
        columnName: '_id',
        allowFiltering : true,
        allowSorting : true,
        columnWidthMode : ColumnWidthMode.fitByColumnName,
        label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text(
            '#',
          ),
        ),
      ),
      GridColumn(
          columnName: '_date',
          allowFiltering : true,
          allowSorting : true,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('التاريخ'))),
      GridColumn(
          columnName: '_time',
          allowFiltering : true,
          allowSorting : true,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'الوقت',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: '_account_no',
          allowFiltering : true,
          allowSorting : true,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('رقم الحساب'))),
      GridColumn(
          columnName: '_account_name',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('اسم الحساب'))),

      GridColumn(
          columnName: '_jornal',
          allowFiltering : false,
          allowSorting : true,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('رقم القيد'))),

      GridColumn(
          columnName: '_amount',
          allowFiltering : false,
          allowSorting : false,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('قيمة الفاتورة'))),
      GridColumn(
          columnName: '_disscount',
          allowFiltering : false,
          allowSorting : false,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('قيمة الخصم'))),
      GridColumn(
          columnName: '_amount_all',
          allowFiltering : false,
          allowSorting : false,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('قيمة الفاتورة الكلية'))),
      GridColumn(
          columnName: '_currency',
          allowFiltering : false,
          allowSorting : false,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('عملة الفاتورة'))),
      GridColumn(
          columnName: '_rate',
          allowFiltering : false,
          allowSorting : false,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('قيمة العملة'))),
      GridColumn(
          columnName: '_payment',
          allowFiltering : false,
          allowSorting : false,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('المدفوع'))),
      GridColumn(
          columnName: '_payment_currency',
          allowFiltering : false,
          allowSorting : false,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('عملة المدفوع'))),
      GridColumn(
          columnName: '_remaining',
          allowFiltering : false,
          allowSorting : false,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('المتبقي'))),


      GridColumn(
          columnName: '_discription',
          allowFiltering : false,
          allowSorting : false,
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('الملاحظات'))),

    ];
  }
}

