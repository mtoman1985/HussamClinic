import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:hussam_clinc/main.dart';
import 'package:hussam_clinc/pages/costumer/PageEditCostumers.dart';
import '../../db/patients/dbpatient.dart';
import '../../model/patients/PatientModel.dart';
import 'PageAddCostumers.dart';

List<PatientModel> costumers_search=[];
const _headerStyle = TextStyle(
    color: Color(0xffffffff), fontSize: 18, fontWeight: FontWeight.bold);
const _contentStyleHeader = TextStyle(
    color: Color(0xff999999), fontSize: 16, fontWeight: FontWeight.w700);
const _contentStyle = TextStyle(
    color: Color(0xff999999), fontSize: 15, fontWeight: FontWeight.normal);


InputDecoration inputDecoration (String hintText) {
  return InputDecoration(
    hintText:hintText,
    hintStyle: const TextStyle(fontSize: 20),
    errorStyle: const TextStyle(fontSize: 14),
    focusColor: Colors.lightGreen,
    enabledBorder: InputBorder.none,
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(width: 4, color: Colors.blue),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
          width: 2, color: Color(0xffF02E65)),
    ),
    border: InputBorder.none,
  );
}
class PageCostumers extends StatefulWidget{
  List<PatientModel> costumers;
  PageCostumers(this.costumers,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PageCostumersState();
  }
}
class PageCostumersState extends State<PageCostumers>{
  TextEditingController teSeach = TextEditingController();
  TextEditingController texMassege = TextEditingController();
  var allPersonsVar = [];
  DateTime projectStartDate = DateTime.now();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DismissKeyboard(
        child: Scaffold(
          // key: scaffoldKey,
          appBar: AppBar(
            backgroundColor:const Color( 0xFF1D9D99),
            title: const Text(
              'صفحة المرضى',
              style: TextStyle(fontSize: 25,color: Colors.white),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon:Image.asset(
                    "assets/icon/alphabetical_sort_aecs.png",
                    width: 50,
                    height: 50,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.costumers.sort((a, b) => a.name.compareTo(b.name));
                      costumers_search.isNotEmpty? costumers_search.sort((a, b) => a.name.compareTo(b.name)): widget.costumers.sort((a, b) => a.name.compareTo(b.name));
                    });
                  }),
              IconButton(
                  icon: Image.asset(
                    "assets/icon/alphabetical_sort_desc.png",
                    width: 70,
                    height: 70,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.costumers.sort((a, b) => b.name.compareTo(a.name));
                      costumers_search.isNotEmpty? costumers_search.sort((a, b) => b.name.compareTo(a.name)): widget.costumers.sort((a, b) => b.name.compareTo(a.name));
                    });
                  }),
              IconButton(
                  icon:Image.asset(
                    "assets/icon/sort-Ascending.png",
                    width: 50,
                    height: 50,
                    color: Colors.white,
                  ),
                  onPressed: () {
                 setState(() {
                   widget.costumers.sort((a, b) => int.parse(a.fileNo).compareTo( int.parse(b.fileNo)));
                   costumers_search.isNotEmpty? costumers_search.sort((a, b) => int.parse(a.fileNo).compareTo( int.parse(b.fileNo))):widget.costumers.sort((a, b) => int.parse(a.fileNo).compareTo( int.parse(b.fileNo)));
                 });
                  }),
              IconButton(
                  icon: Image.asset(
                    "assets/icon/sort-descending.png",
                    width: 70,
                    height: 70,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.costumers.sort((a, b) =>int.parse(b.fileNo).compareTo(int.parse(a.fileNo)));
                      costumers_search.isNotEmpty? costumers_search.sort((a, b) =>int.parse(b.fileNo).compareTo(int.parse(a.fileNo))): widget.costumers.sort((a, b) =>int.parse( b.fileNo).compareTo(int.parse(a.fileNo)));
                    });
                  }),
              IconButton(
                icon: Image.asset(
                  "assets/icon/adduser.png",
                  width: 40,
                  height: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  DbPatient dbPatient = DbPatient();
                  dbPatient.MaxFileNo();
                  //AllPatientList();
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => const PageAddCostumers()));
                  });
                },
              ),
            ],
          ),
          body: personPageContent(context),
        ),
      ),
    );
  }

  Widget personPageContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, right: 5, left: 5),
      child: Column(
        children: [
          personSearhName(),
          allPersonListView(),
        ],
      ),
    );
  }
  Widget personSearhName() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        onChanged: (value) {
          setState(() {
            filterSeach(value);
          });
        },
        controller: teSeach,
        //focusNode: myFocusNode,
        autofocus: true,
        decoration: const InputDecoration(
          labelStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          hintText: 'البحث بالاسم ...',
          hintStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          labelText: ' البحث عن المريض',
          prefixIcon: Icon(
            color: Color.fromARGB(255, 47, 47, 47),
            Icons.search,
            size: 30,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      ),
    );
  }
  ///TODAD
  Widget allPersonListView() {
    return Expanded(
      child: teSeach.text.toString().isEmpty? personListView():personListViewSearching(),
    );
  }
  Widget personListView() {
    return widget.costumers.isEmpty? const Center(child: CircularProgressIndicator()):
    ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.costumers.length,
        itemBuilder: (context, i) {
          return Dismissible(
            background: const Padding(
              padding: EdgeInsets.all(4.0),
              child: ColoredBox(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding:
                    EdgeInsets.only(top: 10.0, bottom: 10, right: 30),
                    child: Icon(
                      Icons.delete, //add to home screen
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
            secondaryBackground:  Padding(
              padding: EdgeInsets.all(4.0),
              child: ColoredBox(
                color: Colors.green,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/icon/edituser.png",
                      width: 70,
                      height: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            key: UniqueKey(),
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('هل أنت متأكد من حذف المريض'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'لا',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(()  {
                              DbPatient dbPatient = DbPatient();
                              dbPatient.deletePatient(widget.costumers.elementAt(i).id);
                              widget.costumers.removeAt(i);
                            });
                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            'نعم',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              }else if (direction == DismissDirection.endToStart) {
                await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('هل أنت متأكد من تعديل بيانات المريض'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'لا',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                            setState(()  {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) =>  PageEditCostumers(widget.costumers.elementAt(i))));
                            });
                          },
                          child: const Text(
                            'نعم',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              }
            },
            child: cardInformation (widget.costumers,i),
          );
        });
  }
  Widget personListViewSearching() {
    return costumers_search.isEmpty? const Center(child: CircularProgressIndicator()):
    ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: costumers_search.length,
        itemBuilder: (context, i) {
          return Dismissible(
            background: const Padding(
              padding: EdgeInsets.all(4.0),
              child: ColoredBox(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding:
                    EdgeInsets.only(top: 10.0, bottom: 10, right: 30),
                    child: Icon(
                      Icons.delete, //add to home screen
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
            secondaryBackground:  const Padding(
              padding: EdgeInsets.all(4.0),
              child: ColoredBox(
                color: Colors.green,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child:
                    Icon(
                      Icons.edit, //add to home screen
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                ),
              ),
            ),
            key: UniqueKey(),
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('هل أنت متأكد من حذف المريض'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'لا',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(()  {
                              DbPatient dbPatient = DbPatient();
                              dbPatient.deletePatient(costumers_search[i].id);
                              widget.costumers.removeWhere((element) => element.id==costumers_search[i].id);
                              costumers_search.removeAt(i);
                            });
                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            'نعم',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              } else if (direction == DismissDirection.endToStart) {
                await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('هل أنت متأكد من تعديل بيانات المريض'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'لا',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                            setState(()  {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) =>  PageEditCostumers(costumers_search[i])));
                            });
                          },
                          child: const Text(
                            'نعم',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              }
            },
            child:cardInformation (costumers_search,i),
          );
        });
  }

  Widget cardInformation (List<PatientModel> listCostumer,int i)  {
    return  Accordion(
        maxOpenSections: 2,
        headerBackgroundColorOpened: Colors.black54,
        scaleWhenAnimating: true,
        openAndCloseAnimation: true,
        disableScrolling:true,
        paddingListTop : 5.0,
        paddingListBottom : 2.0,
        headerPadding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
        sectionClosingHapticFeedback: SectionHapticFeedback.light,
        children: [
          AccordionSection(
            isOpen: false,
            leftIcon: const Icon(Icons.person, color: Colors.white,size: 30,),
            header: Text(listCostumer[i].name, style: _headerStyle),
            contentBorderColor: const Color(0xffffffff),
            headerBackgroundColorOpened: Colors.amber,
            content: Accordion(
              maxOpenSections: 1,
              headerBackgroundColorOpened: Colors.black54,
              headerPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              children: [
                AccordionSection(
                  isOpen: true,
                  leftIcon:
                  const Icon(Icons.info, color: Colors.white),
                  headerBackgroundColor: Colors.black38,
                  headerBackgroundColorOpened: Colors.black54,
                  header: const Text('المعلومات الشخصية', style: _headerStyle),
                  content:  DataTable(
                    sortAscending: true,
                    sortColumnIndex: 1,
                    dataRowHeight: 50,
                    showBottomBorder: false,
                    columns: const [
                      DataColumn(
                          label: Text('الوصف', style: _contentStyleHeader)),
                      DataColumn(
                          label: Text('القيمة', style: _contentStyleHeader),
                          numeric: true),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          const DataCell(
                            Text('رقم الملف', style: _contentStyle),
                          ),
                          DataCell(
                            TextFormField(
                              initialValue: listCostumer[i].fileNo,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black45),
                              decoration:inputDecoration('رقم الملف'),
                              textAlignVertical:TextAlignVertical.bottom,
                              textAlign : TextAlign.center,
                              onFieldSubmitted: (val) {
                                setState(() {
                                  listCostumer[i].fileNo!=val!.toString()?
                                  _dialogBuilder(context,listCostumer,i,1,val!):null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text('رقم الجوال', style: _contentStyle),
                          ),
                          DataCell(
                            TextFormField(
                              initialValue: listCostumer[i].mobile,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black45),
                              decoration:inputDecoration('رقم الجوال'),
                              textAlignVertical:TextAlignVertical.bottom,
                              textAlign : TextAlign.center,
                              onFieldSubmitted: (val) {
                                setState(() {
                                  listCostumer[i].mobile!=val!.toString()?
                                  _dialogBuilder(context,listCostumer,i,2,val!):null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text('العنوان', style: _contentStyle),
                          ),
                          DataCell(
                            TextFormField(
                              initialValue: listCostumer[i].address,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black45),
                              decoration:inputDecoration('العنوان'),
                              textAlignVertical:TextAlignVertical.bottom,
                              textAlign : TextAlign.center,
                              onFieldSubmitted: (val) {
                                setState(() {
                                  listCostumer[i].address!=val!.toString()?
                                  _dialogBuilder(context,listCostumer,i,3,val!):null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text('العمر', style: _contentStyle),
                          ),
                          DataCell(
                            TextFormField(
                              initialValue: listCostumer[i].age,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black45),
                              decoration:inputDecoration('العمر'),
                              textAlignVertical:TextAlignVertical.bottom,
                              textAlign : TextAlign.center,
                              onFieldSubmitted: (val) {
                                setState(() {
                                  listCostumer[i].age!=val!.toString()?
                                  _dialogBuilder(context,listCostumer,i,4,val!):null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(
                            Text('اسم المريض', style: _contentStyle),
                          ),
                          DataCell(
                            TextFormField(
                              initialValue: listCostumer[i].name,
                              style: const TextStyle(color: Colors.black45),
                              decoration:inputDecoration('اسم المريض'),
                              textAlignVertical:TextAlignVertical.bottom,
                              textAlign : TextAlign.center,
                              onFieldSubmitted: (val) {
                                setState(() {
                                  listCostumer[i].name!=val!.toString()?
                                  _dialogBuilder(context,listCostumer,i,5,val!):null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]
    );
  }
  Future<void> _dialogBuilder(BuildContext context,List<PatientModel> listCostumer, int i ,int k,String value ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:TextDirection.rtl,
          child: AlertDialog(
            title: const Text('التـعـديــــــل '),
            content: const Text('هل تريد فعلا إجراء هذا التعديل',style:_contentStyleHeader ),
            actions: <Widget>[
              IconButton(onPressed:() {
                switch (k) {
                  case 1:
                    listCostumer[i].fileNo=value.toString();
                    break;
                  case 2:
                    listCostumer[i].mobile=value.toString();
                    break;
                  case 3:
                    listCostumer[i].address=value.toString();
                    break;
                  case 4:
                    listCostumer[i].age=value.toString();
                    break;
                  case 5:
                    listCostumer[i].name=value.toString();
                    break;
                  case 6:
                  //  listCostumer[i].costumer_lawer_type=value.toString();
                    break;
                  case 7:
                  //  listCostumer[i].costumer_mahkma=value.toString();
                    break;
                }
                updateCostumers(context, listCostumer[i]);
                Navigator.of(context).pop();
              },
                  icon:const Icon(Icons.save,
                      size:40,
                      color:Colors.green)
              ),
              const SizedBox(
                width: 40,
              ),
              IconButton(
                onPressed:() {
                  Navigator.of(context).pop();
                },
                icon:const Icon(Icons.cancel_outlined,
                  size:40,
                ),
                color: Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }
  //
  updateCostumers(context,PatientModel mapC) async {
    DbPatient dbPatient = DbPatient();
    dbPatient.updatePatient(mapC.id,mapC);
  }

  void filterSeach(String query) async {
    setState(() {
      costumers_search.clear();
      for (var element in allPatient) {
        if( element.name.contains(query)){
          costumers_search.add(element);
        }
      }
    });
  }

  String message = "message";
  List<String> recipents = [];

  Future<DateTime?> pickDate(context) {
    return showDatePicker(
      context: context,
      initialDate: projectStartDate,
      firstDate: DateTime(2017),
      lastDate: DateTime(2520),
    );
  }
}///End widget

/// The DismissKeybaord widget (it's reusable)
class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }

}