import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hussam_clinc/View_model/ViewModelExpenseInvoices.dart';
import 'package:hussam_clinc/dialog/accounting/select_persons_group.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../dialog/accounting/select_trees.dart';
import '../../../global_var/globals.dart';
import '../../../main.dart';
import '../../../reports/reportExpenseInvoicePDF.dart';

class ExpenseInvoices extends StatefulWidget{
  const ExpenseInvoices({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ExpenseInvoicesState();
  }
}

var VMExpenseInvoice = ViewModelExpenseInvoices.impty();

class ExpenseInvoicesState extends State<ExpenseInvoices>{
  @override
  void dispose (){
    super.dispose();

    VMExpenseInvoice.saving=false;
  }
  @override
  void initState() {
    super.initState();
    if(VMExpenseInvoice.saving==false) {
      VMExpenseInvoice= ViewModelExpenseInvoices.impty();
    }
    VMExpenseInvoice.checkValues();
    VMExpenseInvoice.checkValues2();
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
              'فاتورة شراء',
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
              ThirdRow(VMExpenseInvoice.AccountingPerson_select_id),
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
                reportExpenseInvoicePDF InvoiceReport=reportExpenseInvoicePDF();
                InvoiceReport.inti();
                InvoiceReport.stateManager= VMExpenseInvoice.stateManager;
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
                VMExpenseInvoice.stateManager.removeCurrentRow();
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
                VMExpenseInvoice.AddNewRecord();
              });
            }),
        IconButton(
            iconSize:40,
            icon:Icon(
                VMExpenseInvoice.saving? Icons.edit:Icons.save,
                color:Colors.white
            ),
            onPressed: () {
              setState(() {
                /// the record is execces you must update record
                if(VMExpenseInvoice.saving){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    action: SnackBarAction(
                      textColor:Colors.white,
                      backgroundColor:Colors.pinkAccent,
                      label: '  تعديل  فاتورة الشراء ',
                      onPressed: () {
                        ///Todo Edite Invoices
                        VMExpenseInvoice.EditeInvoices(VMExpenseInvoice.MaxInvoices);
                        VMExpenseInvoice.saving=true;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor:Colors.blue,
                          content: Text(
                            ' تم تعديل  فاتورة الشراء بنجاح ',
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
                          ' لم يتم تعديل فاتورة الشراء ',
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
                      label: 'تأكيد  إضافة  فاتورة الشراء ',
                      onPressed: () {
                        VMExpenseInvoice.AddNewInvoices();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor:Colors.green,
                          content: Text(
                            ' تم إضافة  فاتورة الشراء بنجاح ',
                            style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color:Colors.white),
                          ),
                          duration: Duration(seconds: 4),
                        ));
                        AllPatientList();
                        copyExternalDB();
                        setState(() {
                          VMExpenseInvoice.saving=true;
                        });
                      },
                    ),
                    content: const Column(
                      children: [
                        Text(
                          ' لم يتم إضافة  فاتورة الشراء ',
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
            Text( 'رقم الفاتورة : ',style:  VMExpenseInvoice.textStyleLabel, ),
            Text( VMExpenseInvoice.Maxjournals,style:  VMExpenseInvoice.textStyle, ),
          ],
        ),
        const SizedBox(width: 15),
        InkWell(
          onTap:() async {
            final date = await  VMExpenseInvoice.pickDate(context);
            if (date == null) return;
            setState(() {
              VMExpenseInvoice.dateDate = date;
            });
          },
          child:
          Row(
            children: [
              Text(
                'التاريخ  :  ',
                style:  VMExpenseInvoice.textStyleLabel,
              ),
              Text(
                '${ VMExpenseInvoice.dateDate.year}/${ VMExpenseInvoice.dateDate.month}/${ VMExpenseInvoice.dateDate.day}',
                style:VMExpenseInvoice.textStyle,
              ),
            ],
          ),
        ) ,
        const SizedBox(width: 15),
        InkWell(
          onTap:() async {
            VMExpenseInvoice.Selectedtime = (await  VMExpenseInvoice.picktime(context))!;
          },
          child:
          Row(
            children: [
              Text(
                'الساعة  :  ',
                style: VMExpenseInvoice.textStyleLabel,
              ),
              Text(
                '${VMExpenseInvoice.Selectedtime.hour}:${VMExpenseInvoice.Selectedtime.minute}',
                style:VMExpenseInvoice.textStyle,
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
              setState(() {
                showDialog(
                    context: context,
                    builder: (context) {
                      //  setState(() {
                      return SelectTrees();
                      //   });
                    });
              });
            },
            child: Row(
              children: [
                const SizedBox(width: 3),
                Text( 'الرقم  :   ',style: VMExpenseInvoice.textStyleLabel, ),
                const SizedBox(width: 2),
                Text('${VMExpenseInvoice.AccountingTo_select_id} ',style: VMExpenseInvoice.textStyle,),
              ],
            ),
          ) ,
          const SizedBox(width: 45),
          Row(
              children: [
                const SizedBox(width: 3),
                Text( 'الاسم  :   ',style: VMExpenseInvoice.textStyleLabel, ),
                const SizedBox(width: 2),
                Text('${VMExpenseInvoice.AccountingTo_select_name} ',style: VMExpenseInvoice.textStyle,),
              ]),
        ],
      ),
    );
  }
  Widget ThirdRow(String accountingPersonSelectId) {
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
              VMExpenseInvoice.AccountingPerson_select_name='';
              VMExpenseInvoice.checkValues2();
            });
          },
          child:   Row(
            children: [
              const SizedBox(width: 3),
              Text( 'الرقم  : ',style: VMExpenseInvoice.textStyleLabel, ),
              const SizedBox(width: 2),
              Text(accountingPersonSelectId,style: VMExpenseInvoice.textStyle,),
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
              items:VMExpenseInvoice.persons,
              selectedItem:VMExpenseInvoice.AccountingPerson_select_name,
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
                  VMExpenseInvoice.AccountingPerson_select_name=value!;
                  VMExpenseInvoice.selecedId(value);
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
            value:VMExpenseInvoice.currencySelect,
            hint: const Text('العملة'),
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_downward),
            isExpanded:true,
            selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
              return VMExpenseInvoice.currnceyList
                  .map((String value) {
                return Center(
                  child: Text(
                    VMExpenseInvoice.currencySelect,
                    style: const TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                  ),
                );
              }).toList();
            },
            // Array list of items
            items: VMExpenseInvoice.currnceyList.map((String items) {
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
                VMExpenseInvoice.currencySelect=value.toString();
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
            initialValue: VMExpenseInvoice.rate.toString(),
            onChanged: (val) {
              setState(() {
                VMExpenseInvoice.rate =  double.parse(val)  ;
              });
            },
            onSaved: (val) {
              VMExpenseInvoice.rate = double.parse(val!);
            },
            keyboardType: const TextInputType.numberWithOptions(),
            // validate after each user interaction
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 16),
            decoration: VMExpenseInvoice.inputDecorationNoIcon("سعر العملة "),
          ),
        ),
      ],
    );
  }

  PlutoGrid tabledata (){
    return PlutoGrid(
      columns: VMExpenseInvoice.columns,
      rows: VMExpenseInvoice.rows,
      onLoaded: (event) {
        VMExpenseInvoice.stateManager = event.stateManager;
        VMExpenseInvoice.stateManager.setShowColumnFilter(false);
      },
      rowColorCallback:  (PlutoRowColorContext rowColorContext) {
        return rowColorContext.row.cells['id']?.value == '0'
            ? const Color(0xFFDABED1)
            : const Color(0xFFE2F6DF);
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        PlutoRow currentRow=VMExpenseInvoice.stateManager.currentRow!;
        VMExpenseInvoice.selecedIndexId(currentRow.cells['name']!.value.toString());
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
        VMExpenseInvoice.amount=0;
        VMExpenseInvoice.stateManager.rows.forEach((e) {
          VMExpenseInvoice.amount+= e.cells['total']!.value;
        });
        setState(() {
          VMExpenseInvoice.amount_all=VMExpenseInvoice.amount-VMExpenseInvoice.disscount;
          VMExpenseInvoice.remaining= VMExpenseInvoice.amount_all-VMExpenseInvoice.payment;
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
              Text( 'مبلغ الفاتورة  : ',style: VMExpenseInvoice.textStyleLabel, ),
              const SizedBox(width: 12),
              Text('${VMExpenseInvoice.amount} ${VMExpenseInvoice.currencySelect}',style: VMExpenseInvoice.textStyle,),
            ],
          ) ,
          const SizedBox(height: 20),
          Row(
            children: [
              Row(
                children: [
                  Text( 'قيمة الخصم  : ',style:VMExpenseInvoice.textStyleLabel, ),
                  SizedBox(
                    height: 45,
                    width: 150,
                    child: TextFormField(
                      textAlign : TextAlign.center,
                      initialValue: VMExpenseInvoice.disscount.toString(),
                      onChanged: (val) {
                        setState(() {
                          VMExpenseInvoice.disscount =double.parse(val)  ;
                          VMExpenseInvoice.amount_all=VMExpenseInvoice.amount-VMExpenseInvoice.disscount;
                          VMExpenseInvoice.remaining= VMExpenseInvoice.amount_all-VMExpenseInvoice.payment;
                        });
                      },
                      keyboardType: const TextInputType.numberWithOptions(),
                      // validate after each user interaction
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(fontSize: 16),
                      decoration: VMExpenseInvoice.inputDecorationNoIcon("قيمة الخصم "),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 50),
              Row(
                children: [
                  Text( 'مدفوع نقدا  : ',style: VMExpenseInvoice.textStyleLabel, ),
                  SizedBox(
                    height: 45,
                    width: 150,
                    child: TextFormField(
                      textAlign : TextAlign.center,
                      initialValue: VMExpenseInvoice.payment.toString(),
                      onChanged: (val) {
                        setState(() {
                          VMExpenseInvoice.payment =double.parse(val)  ;
                          VMExpenseInvoice.remaining= VMExpenseInvoice.amount_all-VMExpenseInvoice.payment;
                        });
                      },
                      keyboardType: const TextInputType.numberWithOptions(),
                      // validate after each user interaction
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(fontSize: 16),
                      decoration: VMExpenseInvoice.inputDecorationNoIcon("قيمة الخصم "),
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
                      value:VMExpenseInvoice.payment_currency,
                      hint: const Text('العملة'),
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_downward),
                      isExpanded:true,
                      selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
                        return VMExpenseInvoice.currnceyList
                            .map((String value) {
                          return Center(
                            child: Text(
                              VMExpenseInvoice.payment_currency,
                              style: const TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList();
                      },
                      // Array list of items
                      items: VMExpenseInvoice.currnceyList.map((String items) {
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
                          VMExpenseInvoice.payment_currency=value.toString();
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
              Text( 'مبلغ الفاتورة الإجمالي : ',style: VMExpenseInvoice.textStyleLabel, ),
              const SizedBox(width: 12),
              Text('${VMExpenseInvoice.amount_all} ${VMExpenseInvoice.currencySelect}',style: VMExpenseInvoice.textStyle,),
            ],
          ) ,
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment : MainAxisAlignment.start,
            children: [
              Text( ' المبلغ المتبقي : ',style: VMExpenseInvoice.textStyleLabel, ),
              const SizedBox(width: 12),
              Text('${VMExpenseInvoice.remaining} ${VMExpenseInvoice.currencySelect}',style: VMExpenseInvoice.textStyle,),
            ],
          ) ,
        ],
      ),
    );
  }
}





