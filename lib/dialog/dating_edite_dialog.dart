import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:hussam_clinc/db/dbdate.dart';
import 'package:hussam_clinc/db/patients/dbpatient.dart';
import 'package:hussam_clinc/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart' as picked;
import 'package:timetable/timetable.dart';
import '../data/positioning_demo.dart';
import '../db/dbemployee.dart';
import '../main.dart';
import '../model/Employment/EmployeeModel.dart';
import '../model/patients/PatientModel.dart';



class DatingEditeDialog extends StatefulWidget {
  final String title, positiveBtnText, negativeBtnText;
  DatingEditeDialog({
    super.key,
    required this.title,
    required this.positiveBtnText,
    required this.negativeBtnText,
  });
  @override
  State<StatefulWidget> createState() => _DatingEditeDialogState();
}

class _DatingEditeDialogState extends State<DatingEditeDialog> {
  List<String> listPersons = [];
  List<String> listDoctors = [];
  List<String> listChecks = [];
  List<picked.TimeRange>? disabledListedTime=[];
  List<Color>? disabledListedColor=[];
  List checks_list = [];
  final String positiveBtnText = "حفظ";
  final String negativeBtnText = "إلفاء الأمر";
  final String title = "تعديل الموعد";
  final _dateDoctorName = GlobalKey<FormState>();
  final _datePlace = GlobalKey<FormState>();
  final TextEditingController _dateNote = TextEditingController();

  final datePlaceList = ['غرفة 1', 'غرفة 2', 'غرفة 3'];
  String datePlace = selected_event_Model.place;
  String selectPatintList = selected_event_Model.costumerName;
  String selectDoctorList =selected_event_Model.doctorName;
  String selectPatintID = selected_event_Model.costumerId;
  String selectDoctorID = selected_event_Model.doctorId;
  DateTime dateDate =DateTime.parse(selected_event_Model.dateStart)  ;
  DateTime startDate =DateTime.parse(selected_event_Model.dateStart)  ;
  DateTime endDate =DateTime.parse(selected_event_Model.dateEnd)  ;
  TimeOfDay StartTime = TimeOfDay(hour:TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  TimeOfDay EndTime =TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute+10);
  TimeOfDay ChangeTime = TimeOfDay.now();
  DateTime Start = DateTime.now().atStartOfDay;
  DateTime End = DateTime.now().atStartOfDay;
  String dateNote = selected_event_Model.note;

  void selecedtdatePlaceList() {
    datePlace =datePlaceList.contains(datePlace)?datePlace:datePlaceList[0] ;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      StartTime = TimeOfDay(hour:startDate.hour, minute: startDate.minute);
      EndTime =TimeOfDay(hour:endDate.hour, minute: endDate.minute);
      Start = startDate.atStartOfDay;
      End = endDate.atStartOfDay;
      selecedPatientList();
      selecedDoctorList();
      CheckDated(dateDate,datePlace,selectDoctorList);
      for(int i=0;i<50;i++) {
        disabledListedColor!.add(Color(Random().nextInt(0xffffffff)).withAlpha(0xff));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selecedtdatePlaceList();
    if (listPersons.isEmpty) {
      return const CircularProgressIndicator();
    } else {
      selectPatintList =listPersons.contains(selectPatintList)?selectPatintList:listPersons[0] ;
      selectDoctorList =listDoctors.contains(selectDoctorList)?selectDoctorList:listDoctors[0];
      selecedPatientId(selectPatintList);
      selecedDoctorId (selectDoctorList);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildDialogContent(context),
        ),
      );
    }
  }

  Widget _buildDialogContent(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth:500,
            maxHeight: 900,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                // Bottom rectangular box
                margin: const EdgeInsets.only(
                  top: 40,
                ), // to push the box half way below circle
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 8,
                  right: 8,
                ), // spacing inside the box
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      title,
                      style: CustomTheme.lightTheme.textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const TabBar(
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.home,
                            color: Colors.black,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 650,
                      width: 430,
                      child: GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: TabBarView(
                          children: [
                            Container(
                              child: textEditFisrtPage(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                // Top Circle with icon
                maxRadius: 40.0,
                child:Icon(
                  Icons.add_alert_rounded,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget textEditFisrtPage(BuildContext context) {
    return ListView(
      children:[
        Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            // Date
            TextButton(
              onPressed: () async {
                final date = await pickDate(context);
                if (date == null) return;
                setState(() {
                  dateDate = date;
                  CheckDated(dateDate,datePlace,selectDoctorList);
                  Start=date;
                  End=date;
                });
              },
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    const Text(
                      'التاريخ  :  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${dateDate.year}/${dateDate.month}/${dateDate.day}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            //  "اسم الدكتور"
            DropdownButtonFormField(
              key: _dateDoctorName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 18,
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
                size: 30,
              ),
              alignment: AlignmentDirectional.centerEnd,
              decoration: const InputDecoration(
                labelText: " اسم الدكتور ",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 18,
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 35,
                ),
              ),
              value: selectDoctorList,
              items: listDoctors.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(
                      minHeight: 48.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          e,
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onTap: () {},
              onChanged: (val) {
                selectDoctorList = val as String;
                CheckDated(dateDate,datePlace,selectDoctorList);
                selecedDoctorId (selectDoctorList);
              },
            ),
            const SizedBox(
              height: 5,
            ),
            //  " المكان "
            DropdownButtonFormField(
              key: _datePlace,
              alignment: AlignmentDirectional.center,
              value: datePlace,
              items: datePlaceList.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          e,
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  datePlace = val as String;
                  CheckDated(dateDate,datePlace,selectDoctorList);
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
                size: 35,
              ),
              decoration:  InputDecoration(
                  labelText: "رقم الغرفة",
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  prefixIcon:
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 2.0,end:3),
                    child: Image.asset(
                      "assets/icon/dentist_chair.png",
                      width: 40,
                      height: 40,
                      color: Colors.blue,
                    ), // _myIcon is a 48px-wide widget.
                  )
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text('وقت البداية',style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16,
                ),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await picked.showTimeRangePicker(
                      context: context,
                      paintingStyle: PaintingStyle.fill,
                      start:StartTime,// const TimeOfDay(hour: StartTime!.hours, minute: 0),
                      end:EndTime,// const TimeOfDay(hour: 10, minute: 30),
                      disabledListedTime:disabledListedTime,
                      disabledListedColor:disabledListedColor,//[Colors.deepOrangeAccent,Colors.deepPurpleAccent,Colors.redAccent,],
                      disabledTime: picked.TimeRange(
                          startTime: const TimeOfDay(hour: 21, minute: 0),
                          endTime: const TimeOfDay(hour: 8, minute: 0)),
                      disabledColor: Colors.green,
                      onStartChange: (start) {
                        if (kDebugMode) {
                          // print("start time $start");
                          setState(() => StartTime = start);
                        }
                      },
                      onEndChange: (end) {
                        if (kDebugMode) {
                          //print("end time $end");
                          setState(() => EndTime = end);
                        }
                      },
                      interval: const Duration(minutes: 10),
                      minDuration: const Duration(minutes: 15),
                      maxDuration: const Duration(hours: 3),
                      use24HourFormat: false,
                      padding: 30,
                      strokeWidth: 20,
                      handlerRadius: 8,
                      strokeColor: Colors.green.withOpacity(0.3),
                      handlerColor: Colors.orange[700],
                      selectedColor: Colors.purpleAccent,
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      ticks: 72,
                      ticksColor: Colors.white,
                      snap: true,
                      labels:[
                        "12am",
                        "1am",
                        "2am",
                        "3am",
                        "4am",
                        "5am",
                        "6am",
                        "7am",
                        "8am",
                        "9am",
                        "10am",
                        "11am",
                        "12pm",
                        "1pm",
                        "2pm",
                        "3pm",
                        "4pm",
                        "5pm",
                        "6pm",
                        "7pm",
                        "8pm",
                        "9pm",
                        "10pm",
                        "11pm",
                        "12pm"
                      ].asMap().entries.map((e) {
                        return picked.ClockLabel.fromIndex(
                            idx: e.key, length: 24, text: e.value);
                      }).toList(),
                      labelOffset: -30,
                      labelStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      timeTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                      activeTimeTextStyle: const TextStyle(
                          color: Colors.pink,
                          fontSize: 26,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    );
                    // setState(() => StartTime = Selectedtime);
                  },
                  child: Text(
                      '${StartTime.hour.toString().padLeft(2, '0')}:${StartTime.minute.toString().padLeft(2, '0')}'),
                ),
                const SizedBox(
                  width: 40,
                ),
                const Text('وقت النهاية',style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16,
                ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {

                  },
                  child: Text(
                      '${EndTime.hour.toString().padLeft(2, '0')}:${EndTime.minute.toString().padLeft(2, '0')}'),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            DropdownSearch<String>(
              selectedItem:selectPatintList,
              popupProps: const PopupProps.menu(
                fit : FlexFit.loose,
                showSelectedItems: true,
                showSearchBox : true,
              ),
              items:listPersons,
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
                  labelText: "اسم المريض",
                  labelStyle:TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  hintText: "اختار اسم المريض",
                ),
              ),
              onChanged:(value) {
                setState(() {
                  selectPatintList = value as String;
                  selecedPatientId(value);
                });
              },
              //selectedItem: "",
            ),

            const SizedBox(
              height: 2,
            ),
            TextFormField(
              //controller: _dateNote,
              initialValue:dateNote ,
              maxLines:3,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  dateNote = value;
                }
              },
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.note_alt_rounded,
                  size: 35,
                  color: Colors.blue,
                ),
                labelText: ' الملاحظات',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                errorStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'يجب أن لا يكون فارغاً';
                }
                if (text.length < 1) {
                  return 'الرقم صغير يجب أن لا يقل عن 1';
                }
                return null;
              },
            ),
            Divider(),
            const SizedBox(
              height: 5,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if ((StartTime.hour==EndTime.hour && StartTime.minute>EndTime.minute)||StartTime.hour>EndTime.hour) {
                    ChangeTime=EndTime;
                    EndTime = StartTime;
                    StartTime = ChangeTime;
                  }
                  Start= Start.add(Duration(hours:StartTime.hour,minutes:StartTime.minute));
                  End= End.add(Duration(hours:EndTime.hour,minutes:EndTime.minute));
                });
                if (StartTime.hour==EndTime.hour && (StartTime.minute==EndTime.minute || (EndTime.minute-StartTime.minute).abs()<9)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      ' لم يتم تعديل  الموعد لأن موعد البداية أكثر بعشر دقائق  ',
                      style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                    ),
                    duration: Duration(seconds: 4),
                  ));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      'تم تعديل الموعد',
                      style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                    ),
                    duration: Duration(seconds: 4),
                  ));
                  DbDate dbDate = DbDate();
                  selected_event_Model.dateStart=Start.toString();
                  selected_event_Model.dateEnd=End.toString();
                  selected_event_Model.place=datePlace;
                  selected_event_Model.note=dateNote;
                  selected_event_Model.doctorId=selectDoctorID;
                  selected_event_Model.doctorName=selectDoctorList;
                  selected_event_Model.costumerId=selectPatintID;
                  selected_event_Model.costumerName=selectPatintList;

                  dbDate.updateDate(selected_event_Model.id, selected_event_Model);
                  Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'تعديل الموعد',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Icon(
                    Icons.save_outlined,
                    size: 30,
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }


  Future<DateTime?> pickDate(context) {
    return showDatePicker(
      context: context,
      initialDate: dateDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2620),
    );
  }

  void CheckDated(DateTime date,String room,String DoctorName) {
    disabledListedTime!.clear();
    if (DatesListUniq.contains(DateTime.utc(date.year, date.month, date.day))){
      picked.TimeRange timeRange=  picked.TimeRange(startTime: const TimeOfDay(hour: 8, minute: 0), endTime: const TimeOfDay(hour: 9, minute: 00));
      disabledListedTime!.contains(timeRange)? null: disabledListedTime!.add(timeRange);
      DatesList.forEach((Dating) {
        DateTime timeStart = DateTime.parse(Dating.dateStart);
        DateTime timeEnd = DateTime.parse(Dating.dateEnd);
        /// Doctor Date
        if (DateTime.utc(timeStart.year,timeStart.month, timeStart.day)==DateTime.utc(date.year,date.month, date.day)){
          /// Doctor Find
          if (Dating.doctorName == DoctorName) {
            /// Room Find
            if (Dating.place == room) {
              // Exist DoctorName and Exist room
              // close other Side of Time
              if (timeStart.hour==9){
                picked.TimeRange timeRange=  picked.TimeRange(startTime:  const TimeOfDay(hour: 15, minute: 00), endTime:  const TimeOfDay(hour:21, minute:00));
                disabledListedTime!.add(timeRange);
              }else{
                picked.TimeRange timeRange=  picked.TimeRange(startTime:  const TimeOfDay(hour: 9, minute: 00), endTime:  TimeOfDay(hour:15, minute:00));
                disabledListedTime!.add(timeRange);
              }

              allDatesList.forEach((Dating) {
                DateTime Time_Start_P = DateTime.parse(Dating.dateStart);
                DateTime Time_End_P = DateTime.parse(Dating.dateEnd);
                DateTime Date = DateTime.parse(Dating.dateStart).atStartOfDay;
                Date=DateTime.utc(Date.year, Date.month, Date.day);

                if ((Date==DateTime.utc(date.year, date.month, date.day)) ){
                  if (Dating.place==room){
                    setState(() {
                      picked.TimeRange timeRange=  picked.TimeRange(startTime:  TimeOfDay(hour: Time_Start_P.hour, minute: Time_Start_P.minute), endTime:  TimeOfDay(hour:Time_End_P.hour, minute: Time_End_P.minute));
                      disabledListedTime!.add(timeRange);
                    });
                  }
                }
              });
            } else {
              // Exist DoctorName and Not Exist room
              print(
                  ' غير موجودة هذه الحالة ');
              picked.TimeRange timeRange=  picked.TimeRange(startTime: const TimeOfDay(hour: 9, minute: 0), endTime: const TimeOfDay(hour: 21, minute: 00));
              disabledListedTime!.add(timeRange);
            }
          }
          else {
            ///Not Exist DoctorName
            if (Dating.place == room) {
              //Not Exist DoctorName and Exist room
              setState(() {
                picked.TimeRange timeRange = picked.TimeRange(
                    startTime: TimeOfDay(
                        hour: timeStart.hour, minute: timeStart.minute),
                    endTime: TimeOfDay(
                        hour: timeEnd.hour, minute: timeEnd.minute));
                // disabledListedTime!.contains(timeRange)
                //     ? null :
                disabledListedTime!.add(timeRange);
              });
            } else {
              //Not Exist DoctorName and Not Exist room
              print(
                  ' بامكان الحجز باي ميعاد ');
            }
          }
        }
      });
    }else{
      picked.TimeRange timeRange=  picked.TimeRange(startTime: const TimeOfDay(hour: 8, minute: 0), endTime: const TimeOfDay(hour: 9, minute: 00));
      disabledListedTime!.contains(timeRange)? null: disabledListedTime!.add(timeRange);
    }
  }

  Future<void> selecedPatientList() async {
    DbPatient dbPatient = DbPatient();
    dbPatient.allPatients().then((Patients) {
      for (var patient in Patients) {
        setState(() {
          if(patient.name.isNotEmpty) listPersons.add(patient.name.toString());
        });
      }
    });
  }

  Future<void> selecedPatientId(String name) async {
    DbPatient dbPatient = DbPatient();
    dbPatient.searchingPatient(name).then((Patients) {
      Patients!.then((Patient) {
        for (var item in Patient) {
          if (mounted) {
            setState(() {
              PatientModel Patien = PatientModel.fromMap(item);
              selectPatintID=Patien.id.toString();
            });
          }
        }
      });
    });
  }

  Future<void> selecedDoctorId(String name) async {
    DbEmployee dbEmployee = DbEmployee();
    dbEmployee.searchingEmployee(name).then((Employees) {
      Employees!.then((Employee) {
        for (var item in Employee) {
          if (mounted) {
            setState(() {
              EmployeeModel doctor = EmployeeModel.fromMap(item);
              selectDoctorID=doctor.id.toString();
            });
          }
        }
      });
    });
  }

  Future<void> selecedDoctorList() async {
    DbEmployee dbEmployee = DbEmployee();
    dbEmployee.allEmployees().then((employees) {
      for (var item in employees) {
        EmployeeModel employee = EmployeeModel.fromMap(item);
        if (employee.jop=='دكتور'){
          setState(() {
            listDoctors.add(employee.name.toString());
          });
        }
      }
    });
  }

  void addNewDate(String title,DateTime Start,DateTime End ,String place) {
    DbDate dbDate = DbDate();
    int id=1;
    dbDate.lastDate().then((value) {
      setState(() {
        id =value.id;
      });
    });
    Future.delayed(const Duration(seconds: 1), () {
      int no_ofclass=1;
      if(place=='غرفة 1'){
        no_ofclass=2;
      }else if(place=='غرفة 2'){
        no_ofclass=3;
      }else if(place=='غرفة 3'){
        no_ofclass=4;
      }
      positioningDemoEvents.add(_DemoEvent(id, title,no_ofclass,Start,End ));
    });
  }
}

class _DemoEvent extends BasicEvent {

  _DemoEvent(
      int demoId,
      String title,
      int classification,
      DateTime start,
      DateTime end) : super(
    id: '$demoId',
    title: title,
    scale: 0 ,
    direction:'l',
    backgroundColor: _getColor(classification),
    start:  start,
    end: end,
  );

  static Color _getColor(int classfication) {
    if(classfication== 1){
      return Colors.white60;
    }else if(classfication== 2){// romm 1
      return Color(0xFF87cc52);
    }else if(classfication== 3){// romm 2
      return Colors.pinkAccent;
    }else if(classfication== 4){// romm 3
      return Color(0xFFcc52a5);
    }
    else{
      return Color(0xFFccc852);
    }
  }
}