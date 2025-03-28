import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as convert_date;
import 'package:hussam_clinc/model/accounting/invoices/InvoicesModel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:timetable/timetable.dart';

class ExpenseReviewDataSource extends DataGridSource {
  ExpenseReviewDataSource({required List<InvoicesModel> expenseinvoicesData}) {
    _invoicesData  =
        expenseinvoicesData
            .map<DataGridRow>((e) => DataGridRow(cells: [
          DataGridCell<int>(columnName: 'id', value: e.id),
          DataGridCell<String>(columnName: 'date', value:'${DateTime.parse(e.date).day}/${DateTime.parse(e.date).month}/${DateTime.parse(e.date).year}' ),
          DataGridCell<String>(columnName: 'time', value: e.time),
          DataGridCell<String>(columnName: 'account_no', value:e.account_no),
          DataGridCell<String>(columnName: 'account_name', value:e.account_name),
          DataGridCell<String>(columnName: 'jornal', value: e.jornal),
          DataGridCell<String>(columnName: 'amount', value: e.amount),
          DataGridCell<String>(columnName: 'disscount', value: e.disscount),
          DataGridCell<String>(columnName: 'amount_all', value: e.amount_all),
          DataGridCell<String>(columnName: 'currency', value: e.currency),
          DataGridCell<String>(columnName: 'rate', value: e.rate),
          DataGridCell<String>(columnName: 'payment', value: e.payment),
          DataGridCell<String>(columnName: 'payment_currency', value: e.payment_currency),
          DataGridCell<String>(columnName: 'remaining', value: e.remaining),
          DataGridCell<String>(columnName: 'discription', value: e.discription),
        ]))
            .toList();
  }

  List<DataGridRow> _invoicesData  = [];

  @override
  List<DataGridRow> get rows => _invoicesData ;


  // @override
  // Widget? buildTableSummaryCellWidget(
  //     GridTableSummaryRow summaryRow,
  //     GridSummaryColumn? summaryColumn,
  //     RowColumnIndex rowColumnIndex,
  //     String summaryValue) {
  //   return Container(
  //     padding: const EdgeInsets.all(15.0),
  //     child: Text(summaryValue),
  //   );
  // }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    //print(' review');
    /// get colors
    Color getRowBackgroundColor() {
      // final int salary = row.getCells()[3].value;
      // if (salary >= 10000 && salary <= 15000) {
      //   return Colors.blue[300]!;
      // } else if (salary > 15000) {
      //   return Colors.orange[300]!;
      // }

      return Colors.transparent;
    }
    TextStyle? getTextStyle() {
      // final int salary = row.getCells()[3].value;
      // if (salary >= 10000 && salary <= 15000) {
      //   return const TextStyle(color: Colors.white);
      // } else if (salary > 15000) {
      //   return const TextStyle(color: Colors.teal);
      // }
      return const TextStyle(color: Colors.teal,fontSize:16);
    }

    return DataGridRowAdapter(
        color: getRowBackgroundColor(),
        cells: row.getCells().map<Widget>((e) {
          late String cellValue;
         /* if (e.columnName == 'date') {
            cellValue = convert_date.DateFormat.yMd().format(DateTime.parse(e.value).atStartOfDay);
          } else {
            cellValue = e.value.toString();
          }*/
          cellValue = e.value.toString();
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(cellValue.toString(),
              overflow: TextOverflow.ellipsis,
              style: getTextStyle(),
            ),
          );
        }).toList());
  }
}