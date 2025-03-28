import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hussam_clinc/data/TimetableExample.dart';
import 'package:hussam_clinc/data/positioning_demo.dart';
import 'package:hussam_clinc/data/utils.dart';
import 'package:hussam_clinc/dialog/dating_edite_dialog.dart';
import 'package:hussam_clinc/model/DatesModel.dart';
import 'package:timetable/timetable.dart';
import 'dart:ui' as ui;
import '../db/dbdate.dart';
import '../db/dbhelper.dart';
import '../db/patients/dbpatient.dart';
import '../dialog/dating_add_dialog.dart';
import '../global_var/globals.dart';
import '../main.dart';

class TimetableWidgt extends StatefulWidget{
  const TimetableWidgt({super.key, required this.title});
  final String title;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TimetableWidgtState();
  }
}

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
class TimetableWidgtState extends State<TimetableWidgt>{
  final _key = GlobalKey<ExpandableFabState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // // Initialize FFI
    // sqfliteFfiInit();
    // databaseFactory = databaseFactoryFfi;
    helper = DbHelper();
    AllPatientList();
    creatExtFolder("db");
    creatExtFolder("pic");
    creatExtFolder("files");
    creatExtFolder("reports");
    copyExternalDB();
    /// create list Acoounting Persons
    AllAccountingTreeList();
    AllAccountingTreeGroup();
    AllSuppliersTreeList();
    AllEmployeeTreeList();
    AllPaitentsTreeList();
    /// create list  Indexes
    AllAccountingIndexList();
    ///
    VMGlobal.MaxNoS();
    AllInvioces();
  }
  late DbHelper helper;
  Future<void> AllPatientList() async {
    DbPatient dbPatient = DbPatient();
    dbPatient.allPatients().then((Patients) {
      for (var patient in Patients) {
        setState(() {
          allPatient.add(patient);
          MaxFiledNo=int.parse(patient.fileNo)>=int.parse(MaxFiledNo)?patient.fileNo:MaxFiledNo;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Scaffold(
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
            key: _key,
            pos: ExpandableFabPos.right,
            overlayStyle: ExpandableFabOverlayStyle(
              // color: Colors.black.withOpacity(0.5),
              blur: 2,
            ),
            onOpen: () {
              debugPrint('onOpen');
            },
            afterOpen: () {
              debugPrint('afterOpen');
            },
            onClose: () {
              debugPrint('onClose');
            },
            afterClose: () {
              debugPrint('afterClose');
            },
            children: [
              FloatingActionButton.small(
                // shape: const CircleBorder(),
                heroTag: null,
                child: const Icon(Icons.edit),
                onPressed: () {
                  final state = _key.currentState;
                  state!.toggle();
                  if(int.parse(selected_event_id)>0) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DatingEditeDialog(
                            title: "تعديل  الموعد ",
                            positiveBtnText: "حفظ",
                            negativeBtnText: "إلفاء الأمر",
                          );
                        });
                  }else{
                    SnackBar snackBar = const SnackBar(
                      content: Text(" يجب تحديد الموعد أولا ً"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
              FloatingActionButton.small(
                // shape: const CircleBorder(),
                heroTag: null,
                child: const Icon(Icons.add),
                onPressed: () {
                  final state = _key.currentState;
                  state!.toggle();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DatingAddDialog(
                          title: "إضافة موعد جديد ",
                          positiveBtnText: "حفظ",
                          negativeBtnText: "إلفاء الأمر",
                        );
                      });
                  setState(() {
                    refreshList();
                  });
                },
              ),
              FloatingActionButton.small(
                // shape: const CircleBorder(),
                heroTag: null,
                child: const Icon(Icons.delete),
                onPressed: () {
                  final state = _key.currentState;
                  if (state != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      action: SnackBarAction(
                        textColor:Colors.white,
                        backgroundColor:Colors.pinkAccent,
                        label: ' هل تريد الحذف بالفعل ',
                        onPressed: () {
                          DbDate dbDate = DbDate();
                          dbDate.deletedate(int.parse(selected_event_id));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                              ' تم حذف الموعد بنجاح ',
                              style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                            ),
                            duration: Duration(seconds: 4),
                          ));
                          refreshList();
                        },
                      ),
                      content: const Column(
                        children: [
                          Text(
                            'لم يتم حذف الموعد  ',
                            style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                          ),
                        ],
                      ),
                      duration: const Duration(seconds: 4),
                    ));
                    state.toggle();
                  }
                },
              ),
            ],
          ),
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          drawer: drawing(context),
          body:
          userWidget(),
        )
    );
  }

  Widget userWidget() {
    DbDate dbDates = DbDate();
    var map = Map();
    DatesListUniq.clear();
    allDatesList.clear();

    dbDates.GroupDates().then((value) {
      setState(() {
        DatesList=value;
      });
    });

    return FutureBuilder(
      future: dbDates.alldate(),
      builder: (BuildContext context, AsyncSnapshot<List<DateModel>> snapshot) {
        if (snapshot.hasData) {
          for(int i=0;i< snapshot.data!.length;i++) {
            DateModel  e=snapshot.data!.elementAt(i);
            allDatesList.add(e);
            DateTime dateStart = DateTime.parse(e.dateStart).atStartOfDay;
            DateTime dateEnd = DateTime.parse(e.dateEnd).atStartOfDay;
            dateStart=DateTime.utc(dateStart.year, dateStart.month, dateStart.day);
            dateEnd=DateTime.utc(dateEnd.year, dateEnd.month, dateEnd.day);
            if (!map.containsKey(dateStart)) {
              map[dateStart] = 1;
              DatesListUniq.add(dateStart);
            } else {
              map[dateStart] += 1;
            }
            if (!map.containsKey(dateEnd)) {
              map[dateEnd] = 1;
              DatesListUniq.add(dateEnd);
            } else {
              map[dateEnd] += 1;
            }
          }
          return ExampleApp(child: TimetableExample());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  Future<void> refreshList() async {
    setState(() {
      DatesListUniq.clear();
      DatesList.clear();
      allDatesList.clear();
      positioningDemoEvents.clear();
    });
  }

}




