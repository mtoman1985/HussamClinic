import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hussam_clinc/View_model/ViewModelSalesInvoices.dart';
import 'package:hussam_clinc/dialog/accounting/select_persons_group.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../dialog/accounting/select_trees.dart';
import '../../../global_var/globals.dart';
import '../../../main.dart';
import '../../../reports/reportSalesInvoicePDF.dart';

class SalesInvoices extends StatefulWidget{
  const SalesInvoices({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SalesInvoicesState();
  }
}

var VMSalesInvoice = ViewModelSalesInvoices.impty();

class SalesInvoicesState extends State<SalesInvoices>{
  @override
  void dispose (){
    super.dispose();
    VMSalesInvoice.saving=false;
  }
  @override
  void initState() {
    super.initState();
    if(VMSalesInvoice.saving==false) {
      VMSalesInvoice= ViewModelSalesInvoices.impty();
    }
    VMSalesInvoice.checkValues();
    VMSalesInvoice.checkValues2();
  }

  @override
  Widget build(BuildContext context) {
    return
      Directionality(
        textDirection: TextDirection.rtl,
        child:Scaffold(
          appBar: AppBar(
            backgroundColor:const Color( 0xFF1D9D99),
            title: const Text(
              'فاتورة بيع',
              style: TextStyle(fontSize: 25,color: Colors.white),
            ),
            actions:BarActions(),
          ),
          body:
          Column(
            children: [
              const SizedBox(height: 20),
              FisrtRow(),
              const SizedBox(height: 25),
              SecondRow(),
              const SizedBox(height: 25),
              ThirdRow(VMSalesInvoice.AccountingPerson_select_id),
              const SizedBox(height: 25),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: tabledata(),
                ),
              ),
              const SizedBox(height: 15),
              FourRow(),
              const SizedBox(height: 70),
            ],
          ),
        ),
      );
  }
  /// Widgit
  List<Widget>BarActions() {
    return
      <Widget>[
        IconButton(
            iconSize:40,
            icon: const Icon(
                Icons.request_page_rounded,
                color:Colors.white
            ),
            onPressed: () {
              setState(() {
                reportSalesInvoicePDF InvoiceReport=reportSalesInvoicePDF();
                InvoiceReport.inti();
                InvoiceReport.stateManager= VMSalesInvoice.stateManager;
              });
            }),
        IconButton(
            iconSize:40,
            icon: const Icon(
                Icons.delete,
                color:Colors.white
            ),
            onPressed: () {
              setState(() {
                VMSalesInvoice.stateManager.removeCurrentRow();
              });
            }),
        IconButton(
            iconSize:40,
            icon: const Icon(
                Icons.add,
                color:Colors.white
            ),
            onPressed: () {
              setState(() {
                VMSalesInvoice.AddNewRecord();
              });
            }),
        IconButton(
            iconSize:40,
            icon:Icon(
                VMSalesInvoice.saving? Icons.edit:Icons.save,
                color:Colors.white
            ),
            onPressed: () {
              setState(() {
                /// the record is execces you must update record
                if(VMSalesInvoice.saving){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    action: SnackBarAction(
                      textColor:Colors.white,
                      backgroundColor:Colors.pinkAccent,
                      label: '  تعديل  فاتورة البيع ',
                      onPressed: () {
                        ///Todo Edite Invoices
                        VMSalesInvoice.EditeInvoices(VMSalesInvoice.MaxInvoices);
                        VMSalesInvoice.saving=true;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor:Colors.blue,
                          content: Text(
                            ' تم تعديل  فاتورة البيع بنجاح ',
                            style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color:Colors.white),
                          ),
                          duration: Duration(seconds: 4),
                        ));
                        AllPatientList();
                        copyExternalDB();
                      },
                    ),
                    content: const Column(
                      children: [
                        Text(
                          ' لم يتم تعديل فاتورة البيع ',
                          style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                        ),
                      ],
                    ),
                    duration: const Duration(seconds: 5),
                  ));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    action: SnackBarAction(
                      textColor:Colors.white,
                      backgroundColor:Colors.pinkAccent,
                      label: 'تأكيد  إضافة  فاتورة البيع ',
                      onPressed: () {
                        VMSalesInvoice.AddNewInvoices();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor:Colors.green,
                          content: Text(
                            ' تم إضافة  فاتورة البيع بنجاح ',
                            style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color:Colors.white),
                          ),
                          duration: Duration(seconds: 4),
                        ));
                        AllPatientList();
                        copyExternalDB();
                        setState(() {
                          VMSalesInvoice.saving=true;
                        });
                      },
                    ),
                    content: const Column(
                      children: [
                        Text(
                          ' لم يتم إضافة  فاتورة البيع ',
                          style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                        ),
                      ],
                    ),
                    duration: const Duration(seconds: 5),
                  ));
                }//if
              });
            }),
      ];
  }

  Widget FisrtRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Text( 'رقم الفاتورة : ',style:  VMSalesInvoice.textStyleLabel, ),
            Text( VMSalesInvoice.Maxjournals,style:  VMSalesInvoice.textStyle, ),
          ],
        ),
        const SizedBox(width: 15),
        InkWell(
          onTap:() async {
            final date = await  VMSalesInvoice.pickDate(context);
            if (date == null) return;
            setState(() {
              VMSalesInvoice.dateDate = date;
            });
          },
          child:
          Row(
            children: [
              Text(
                'التاريخ  :  ',
                style:  VMSalesInvoice.textStyleLabel,
              ),
              Text(
                '${ VMSalesInvoice.dateDate.year}/${ VMSalesInvoice.dateDate.month}/${ VMSalesInvoice.dateDate.day}',
                style:VMSalesInvoice.textStyle,
              ),
            ],
          ),
        ) ,
        const SizedBox(width: 15),
        InkWell(
          onTap:() async {
            VMSalesInvoice.Selectedtime = (await  VMSalesInvoice.picktime(context))!;
          },
          child:
          Row(
            children: [
              Text(
                'الساعة  :  ',
                style: VMSalesInvoice.textStyleLabel,
              ),
              Text(
                '${VMSalesInvoice.Selectedtime.hour}:${VMSalesInvoice.Selectedtime.minute}',
                style:VMSalesInvoice.textStyle,
              ),
            ],
          ),
        ) ,
      ],
    );
  }
  Widget SecondRow() {
    return  Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap:(){
              //setState(() {
                showDialog(
                    context: context,
                    builder: (context) {
                      //  setState(() {
                      return const SelectTrees();
                      //   });
                    });
              //});
            },
            child: Row(
              children: [
                const SizedBox(width: 3),
                Text( 'الرقم  :   ',style: VMSalesInvoice.textStyleLabel, ),
                const SizedBox(width: 2),
                Text('${VMSalesInvoice.AccountingTo_select_id} ',style: VMSalesInvoice.textStyle,),
              ],
            ),
          ) ,
          const SizedBox(width: 45),
          Row(
              children: [
                const SizedBox(width: 3),
                Text( 'الاسم  :   ',style: VMSalesInvoice.textStyleLabel, ),
                const SizedBox(width: 2),
                Text('${VMSalesInvoice.AccountingTo_select_name} ',style: VMSalesInvoice.textStyle,),
              ]),
        ],
      ),
    );
  }
  Widget ThirdRow(String _AccountingPerson_select_id) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap:(){
            showDialog(
                context: context,
                builder: (context) {
                  return SelectPersonsGroup();
                });
            setState(() {
              VMSalesInvoice.AccountingPerson_select_name='';
              VMSalesInvoice.checkValues2();
            });
          },
          child:   Row(
            children: [
              const SizedBox(width: 3),
              Text( 'الرقم  : ',style: VMSalesInvoice.textStyleLabel, ),
              const SizedBox(width: 2),
              Text(_AccountingPerson_select_id,style: VMSalesInvoice.textStyle,),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width:300,
          child: Form(
            child:
            DropdownSearch<String>(
              popupProps: const PopupProps.menu(
                fit : FlexFit.loose,
                showSelectedItems: true,
                showSearchBox : true,
              ),
              items:VMSalesInvoice.persons,
              selectedItem:VMSalesInvoice.AccountingPerson_select_name,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                baseStyle:TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 18,
                ),
                dropdownSearchDecoration: InputDecoration(
                  icon:Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 35,
                  ),
                  labelStyle:TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  hintText: "اختار الاسم ",
                ),
              ),
              onChanged:(value) {
                setState(() {
                  VMSalesInvoice.AccountingPerson_select_name=value!;
                  VMSalesInvoice.selecedId(value);
                });
              },
              //selectedItem: "",
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          width:80,
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButton(
            // Initial Value
            value:VMSalesInvoice.currencySelect,
            hint: const Text('العملة'),
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_downward),
            isExpanded:true,
            selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
              return VMSalesInvoice.currnceyList
                  .map((String value) {
                return Center(
                  child: Text(
                    VMSalesInvoice.currencySelect,
                    style: const TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                  ),
                );
              }).toList();
            },
            // Array list of items
            items: VMSalesInvoice.currnceyList.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Center(
                  child: Text(items,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              );
            }).toList(),
            onChanged: (Object? value) {
              setState(() {
                VMSalesInvoice.currencySelect=value.toString();
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 100,
          height: 50,
          child: TextFormField(
            textAlign : TextAlign.center,
            initialValue: VMSalesInvoice.rate.toString(),
            onSaved: (val) {
              setState(() {
                VMSalesInvoice.rate =  double.parse(val!);
              });
            },
            onChanged: (val) {
              setState(() {
                VMSalesInvoice.rate =  double.parse(val)  ;
              });
            },
            keyboardType: const TextInputType.numberWithOptions(),
            // validate after each user interaction
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 16),
            decoration: VMSalesInvoice.inputDecorationNoIcon("سعر العملة "),
          ),
        ),
      ],
    );
  }

  PlutoGrid tabledata (){
    return PlutoGrid(
      columns: VMSalesInvoice.columns,
      rows: VMSalesInvoice.rows,
      onLoaded: (event) {
        VMSalesInvoice.stateManager = event.stateManager;
        VMSalesInvoice.stateManager.setShowColumnFilter(false);
      },
      rowColorCallback:  (PlutoRowColorContext rowColorContext) {
        return rowColorContext.row.cells['id']?.value == '0'
            ? const Color(0xFFDABED1)
            : const Color(0xFFE2F6DF);
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        PlutoRow currentRow=VMSalesInvoice.stateManager.currentRow!;
        VMSalesInvoice.selecedIndexId(currentRow.cells['name']!.value.toString());
        currentRow.cells['id_item']!.value=AccountingIndx_select_id;
        ///Check if price
        if(currentRow.cells['price']!.value==0){
          currentRow.cells['price']!.value= int.parse(AccountingIndexModel.selling_price);
        }
        ///Check if Qty is Statficed بضاعة
        if(AccountingIndexModel.type=='بضاعة'){
          if(currentRow.cells['qty']!.value<=int.parse(AccountingIndexModel.balance)){
            currentRow.cells['total']!.value= currentRow.cells['price']!.value*currentRow.cells['qty']!.value;
          }else{
            SnackBar snackBar = const SnackBar(
              content: Text(" يجب أن تكون كمية البضاعة أقل من الكمية المصروفة"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            currentRow.cells['qty']!.value=int.parse(AccountingIndexModel.balance);
            currentRow.cells['total']!.value= currentRow.cells['price']!.value*currentRow.cells['qty']!.value;
          }
        }else{
          currentRow.cells['total']!.value= currentRow.cells['price']!.value*currentRow.cells['qty']!.value;
        }
        VMSalesInvoice.amount=0;
        VMSalesInvoice.stateManager.rows.forEach((e) {
          VMSalesInvoice.amount+= e.cells['total']!.value;
        });
        setState(() {
          VMSalesInvoice.amount_all=VMSalesInvoice.amount-VMSalesInvoice.disscount;
          VMSalesInvoice.remaining= VMSalesInvoice.amount_all-VMSalesInvoice.payment;
        });
      },

      configuration: const PlutoGridConfiguration(
        columnSize: PlutoGridColumnSizeConfig(
          resizeMode : PlutoResizeMode.pushAndPull,
          autoSizeMode:PlutoAutoSizeMode.scale,

        ),
        localeText: PlutoGridLocaleText.arabic(),
        enableMoveHorizontalInEditing:true,
        style:PlutoGridStyleConfig(
          checkedColor:Color(0x11757575),
          evenRowColor: Colors.white12,
        ),
      ),
    );
  }
  Widget FourRow() {
    return Padding(
      padding: const EdgeInsets.only(right: 30,top:10),
      child: Column(
        mainAxisAlignment : MainAxisAlignment.spaceAround,
        crossAxisAlignment :CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment : MainAxisAlignment.start,
            children: [
              Text( 'مبلغ الفاتورة  : ',style: VMSalesInvoice.textStyleLabel, ),
              const SizedBox(width: 12),
              Text('${VMSalesInvoice.amount} ${VMSalesInvoice.currencySelect}',style: VMSalesInvoice.textStyle,),
            ],
          ) ,
          const SizedBox(height: 20),
          Row(
            children: [
              Row(
                children: [
                  Text( 'قيمة الخصم  : ',style:VMSalesInvoice.textStyleLabel, ),
                  SizedBox(
                    height: 45,
                    width: 150,
                    child: TextFormField(
                      textAlign : TextAlign.center,
                      initialValue: VMSalesInvoice.disscount.toString(),
                      onChanged: (val) {
                        setState(() {
                          VMSalesInvoice.disscount =double.parse(val)  ;
                          VMSalesInvoice.amount_all=VMSalesInvoice.amount-VMSalesInvoice.disscount;
                          VMSalesInvoice.remaining= VMSalesInvoice.amount_all-VMSalesInvoice.payment;
                        });
                      },
                      keyboardType: const TextInputType.numberWithOptions(),
                      // validate after each user interaction
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(fontSize: 16),
                      decoration: VMSalesInvoice.inputDecorationNoIcon("قيمة الخصم "),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 50),
              Row(
                children: [
                  Text( 'مدفوع نقدا  : ',style: VMSalesInvoice.textStyleLabel, ),
                  SizedBox(
                    height: 45,
                    width: 150,
                    child: TextFormField(
                      textAlign : TextAlign.center,
                      initialValue: VMSalesInvoice.payment.toString(),
                      onChanged: (val) {
                        setState(() {
                          VMSalesInvoice.payment =double.parse(val)  ;
                          VMSalesInvoice.remaining= VMSalesInvoice.amount_all-VMSalesInvoice.payment;
                        });
                      },
                      keyboardType: const TextInputType.numberWithOptions(),
                      // validate after each user interaction
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(fontSize: 16),
                      decoration: VMSalesInvoice.inputDecorationNoIcon("قيمة الخصم "),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    width:80,
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton(
                      // Initial Value
                      value:VMSalesInvoice.payment_currency,
                      hint: const Text('العملة'),
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_downward),
                      isExpanded:true,
                      selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
                        return VMSalesInvoice.currnceyList
                            .map((String value) {
                          return Center(
                            child: Text(
                              VMSalesInvoice.payment_currency,
                              style: const TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList();
                      },
                      // Array list of items
                      items: VMSalesInvoice.currnceyList.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Center(
                            child: Text(items,
                              style: const TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (Object? value) {
                        setState(() {
                          VMSalesInvoice.payment_currency=value.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment : MainAxisAlignment.start,
            children: [
              Text( 'مبلغ الفاتورة الإجمالي : ',style: VMSalesInvoice.textStyleLabel, ),
              const SizedBox(width: 12),
              Text('${VMSalesInvoice.amount_all} ${VMSalesInvoice.currencySelect}',style: VMSalesInvoice.textStyle,),
            ],
          ) ,
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment : MainAxisAlignment.start,
            children: [
              Text( ' المبلغ المتبقي : ',style: VMSalesInvoice.textStyleLabel, ),
              const SizedBox(width: 12),
              Text('${VMSalesInvoice.remaining} ${VMSalesInvoice.currencySelect}',style: VMSalesInvoice.textStyle,),
            ],
          ) ,
        ],
      ),
    );
  }
}





