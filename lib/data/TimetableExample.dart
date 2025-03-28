import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hussam_clinc/db/dbdate.dart';
import 'package:hussam_clinc/dialog/dating_add_dialog.dart';
import 'package:hussam_clinc/dialog/dating_add_doctors.dart';
import 'package:time/time.dart';
import 'package:timetable/timetable.dart';
import '../db/patients/dbpatient.dart';
import '../dialog/message_send.dart';
import '../main.dart';
import '../model/DatesModel.dart';
import 'positioning_demo.dart' ;
import 'dart:math' as math;

final draggedEvents = <BasicEvent>[];
class TimetableExample extends StatefulWidget {
  @override
  State<TimetableExample> createState() => _TimetableExampleState();
}

class _TimetableExampleState extends State<TimetableExample>
    with TickerProviderStateMixin {
  var _visibleDateRange = PredefinedVisibleDateRange.threeDays;
  void _updateVisibleDateRange(PredefinedVisibleDateRange newValue) {
    setState(() {
      _visibleDateRange = newValue;
      _dateController.visibleRange = newValue.visibleDateRange;
    });
  }
  late  DateTime selectedDate=DateTimeTimetable.today();
  List<String> listPersons = [];
  List<BasicEvent>  positioniemoEvents=<BasicEvent>[];
  bool get _isRecurringLayout =>
      _visibleDateRange == PredefinedVisibleDateRange.sevenDays ||_visibleDateRange ==  PredefinedVisibleDateRange.threeDays;
  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String selectDoctorList =allPatient.elementAt(0).name;
  late final _dateController = DateController(
    // All parameters are optional.
    initialDate: DateTimeTimetable.today(),
    //visibleRange: VisibleDateRange.week(startOfWeek: DateTime.saturday),
    visibleRange: _visibleDateRange.visibleDateRange,
  );

  final _timeController = TimeController(
    minDuration: 45.seconds, // The closest you can zoom in.
    maxDuration: 12.hours, // The farthest you can zoom out.
    initialRange:TimeRange(9.hours, 15.hours), //TimeRange((DateTime.now().hour).hours<=10.hours?10.hours:(DateTime.now().hour-2).hours , (DateTime.now().hour).hours>=21.hours?21.hours:(DateTime.now().hour).hours<=10.hours?12.hours:(DateTime.now().hour-2).hours),
    maxRange:TimeRange(8.hours, 22.hours),
  );

  @override
  void initState() {
    // TODO: implement initState
    DatesData();
    selecedPatientList();
    super.initState();
  }
  @override
  void dispose() {
    _timeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child:
      TimetableConfig<BasicEvent>(
        // Required:
        dateController: _dateController,
        timeController: _timeController,
        eventBuilder: (context, event) => _buildPartDayEvent(event),
        // ignore: sort_child_properties_last
        child: Column(children: [
          _buildAppBar(),
          Expanded(
            child: _isRecurringLayout
                ? RecurringMultiDateTimetable<BasicEvent>()
                : MultiDateTimetable<BasicEvent>(),
          ),
        ]),
        eventProvider: eventProviderFromFixedList(positioningDemoEvents),
        allDayEventBuilder: (context, event, info) => BasicAllDayEventWidget(
          event,
          info: info,
          onTap: () => _showSnackBar('All-day event $event tapped'),
        ),
        timeOverlayProvider: mergeTimeOverlayProviders([
          positioningDemoOverlayProvider,
              (context, date) => draggedEvents
              .map(
                (it) =>
                it.toTimeOverlay(date: date, widget: BasicEventWidget(it)),
          )
              .whereNotNull()
              .toList(),
        ]),
        callbacks: TimetableCallbacks(
          onWeekTap: (week) {
            //_showSnackBar('Tapped on week $week.');
            selectedDate=week.getDayOfWeek(1);
            _showSnackBar('  ${week.getDayOfWeek(1)}' );
            _updateVisibleDateRange(PredefinedVisibleDateRange.week);
            _dateController.animateTo(
              week.getDayOfWeek(DateTime.friday),
              vsync: this,
            );
          },
          onDateTap: (date) {
            final weekDay =  date.weekday == 7 ? 0 : date.weekday;
            selectedDate=date.subtract(Duration(days: weekDay));
            _showSnackBar('  تاريخ اليوم المحدد هو : ${date.day}/${date.month}/${date.year} ');
            _dateController.animateTo(date, vsync: this);
          },
          onDateBackgroundTap: (date) =>
              _showSnackBar('Tapped on date background at $date.'),
          onDateTimeBackgroundTap: (dateTime) =>
              _showSnackBar('Tapped on date-time background at $dateTime.'),
          onMultiDateHeaderOverflowTap: (date) =>
              _showSnackBar('Tapped on the overflow of $date.'),
        ),
        theme: TimetableThemeData(
          context,
          //startOfWeek: DateTime.friday,
          dateDividersStyle: DateDividersStyle(
            context,
            color: Colors.blue.withOpacity(.3),
            width: 2,
          ),
          // nowIndicatorStyle: NowIndicatorStyle(
          //   context,
          //   lineColor: Colors.green,
          //   shape: TriangleNowIndicatorShape(color: Colors.green),
          // ),
          timeIndicatorStyleProvider: (time) => TimeIndicatorStyle(
            context,
            time,
            alwaysUse24HourFormat: false,
          ),
        ),
      ),
    );

  }

  Future<void> refreshList() async {
    setState(() {
      DatesListUniq.clear();
      DatesList.clear();
      allDatesList.clear();
      positioningDemoEvents.clear();
    });
    refreshKey.currentState?.show(atTop:true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      SetDateList();
      DatesData();
    });
    return;
  }

  Widget _buildPartDayEvent(BasicEvent event) {
    final roundedTo = 10.minutes;
    String kind='';
    return PartDayDraggableEvent(
      onDragStart: () => setState(() => draggedEvents.add(event)),
      onDragUpdate: (dateTime) => setState(() {
        dateTime = dateTime.roundTimeToMultipleOf(roundedTo);
        final index = draggedEvents.indexWhere((it) => it.id == event.id);
        final oldEvent = draggedEvents[index];
        draggedEvents[index] = oldEvent.copyWith(
          start: dateTime,
          end: dateTime + oldEvent.duration,
        );
      }),
      onDragEnd: (dateTime) {
        dateTime = (dateTime ?? event.start).roundTimeToMultipleOf(roundedTo);
        draggedEvents.removeWhere((it) => it.id == event.id);
        if (dateTime.hour<9||dateTime.hour>=21){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            action: SnackBarAction(
              textColor:Colors.white,
              backgroundColor:Colors.pinkAccent,
              label: ' هل تريد الحذف بالفعل ',
              onPressed: () {
                DbDate dbDate = DbDate();
                dbDate.deletedate(int.parse(event.id.toString()));
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
        }else {
          setState(() {
            DbDate dbDate = DbDate();
            dbDate.searchDatesById(event.id.toString()).then((value) {
              int DurationEvent = event.end
                  .difference(event.start)
                  .inMinutes;
              DateTime Start = DateTime.utc(
                  dateTime!.year, dateTime.month, dateTime.day) +
                  Duration(hours: dateTime.hour, minutes: dateTime.minute);
              value.dateStart = Start.toString();
              DateTime End = Start.add(Duration(minutes: DurationEvent));
              value.dateEnd = End.toString();
              dbDate.updateDate(int.parse(event.id.toString()), value);
            });
          });
          _showSnackBar(' $dateTime تم تغيير الوقت إلى  ');
        }
      },
      onDragCanceled: (isMoved) => _showSnackBar('Your finger moved: $isMoved'),
      child: BasicEventWidget(
        event,
        onDoubleTap:(){
          DbDate dbDate=DbDate();
          dbDate.searchDatesById(event.id.toString()).then((value) {
            kind=value.kind.toString();
          });
          Future.delayed(const Duration(seconds: 1), () {
            if(kind=='مواعيد المرضى') {
              String title = ' اليوم الموافق:   ${event.start.year}/${event.start
                  .month}/${event.start.day}         من الساعة  ${event.start.hour}:${event.start.minute} إلى الساعة ${event.end.hour}:${event.end.minute}   '
                  ' \n  ${event.title}  \n  ${event.end.difference(event.start).inMinutes}   دقيقة ';
              _showSnackBar(title);
            }
          });
        },
        onTap: () {
          DbDate dbDate = DbDate();
          selected_event_id=event.id.toString();

          dbDate.searchDatesById(selected_event_id).then((value) {
            setState(() {
              selected_event_Model=value;
            });
          });
          _showSnackBar('تم تحديد الموعد للتعديل');
       },
      ),
    );
  }

  Widget _buildAppBar() {
    final colorScheme = context.theme.colorScheme;
    Widget child = AppBar(
      elevation: 0,
      titleTextStyle: TextStyle(color: colorScheme.onSurface),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.transparent,
      title: _isRecurringLayout
          ? null
          : MonthIndicator.forController(_dateController),
      actions: [
        const SizedBox(width: 10),
        SizedBox(
        width:300,
          child: DropdownSearch<String>(
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
                fontSize: 16,
              ),
              dropdownSearchDecoration: InputDecoration(
                icon:Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 35,
                ),
                //labelText: "اسم المريض",
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
               // selectPatintList = value as String;
                //selecedPatientId(value);
              });
            },
            //selectedItem: "",
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.refresh_outlined,color: Colors.pinkAccent,),
          onPressed: () {
            refreshList();
          },
          tooltip: 'تحديث',
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.add_alert),
          onPressed: () {
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
          tooltip: 'اضافة مواعيد',
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.today),
          onPressed: () {
            _dateController.animateToToday(vsync: this);
            _timeController.animateToShowFullDay(vsync: this);
          },
          tooltip: 'اذهب إلى تاريخ اليوم',
        ),
        const SizedBox(width: 10),
        DropdownButton(
          onChanged: (visibleRange) => _updateVisibleDateRange(visibleRange!),
          value: _visibleDateRange,
          items: [
            for (final visibleRange in PredefinedVisibleDateRange.values)
              DropdownMenuItem(
                value: visibleRange,
                child: Text(visibleRange.title),
              ),
          ],
        ),
        const SizedBox(width: 20),
      ],
    );

    if (!_isRecurringLayout) {
      child = Column(children: [
        child,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Builder(builder: (context) {
            return DefaultTimetableCallbacks(
              callbacks: DefaultTimetableCallbacks.of(context)!.copyWith(
                onDateTap: (date) {
                  final weekDay =  date.weekday == 7 ? 0 : date.weekday;
                  selectedDate=date.subtract(Duration(days: weekDay));
                  _showSnackBar('Tapped on first of week  date $selectedDate');
                  _updateVisibleDateRange(PredefinedVisibleDateRange.day);
                  _dateController.animateTo(date, vsync: this);
                },
              ),
              child: CompactMonthTimetable(),
            );
          }),
        ),
      ]);
    }
    return Material(color: colorScheme.surface, elevation: 4, child: child);
  }

  void _showSnackBar(String content) =>
      context.scaffoldMessenger.showSnackBar(SnackBar(content: Text(content)));

  Future<DateTime?> pickDate() {
    return showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2620),
    );
  }

  Future<TimeOfDay?> pickMin() {
    return showTimePicker(
      context: context,
      initialTime:
      TimeOfDay(hour: currentTime.hour, minute: currentTime.minute),
    );
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

  void SetDateList() {
    DbDate dbDates = DbDate();
    dbDates.alldate().then((value) {
      setState(() {
        allDatesList=value;
      });
    });


    var map = Map();
    dbDates.GroupDates().then((value) {
      if (value.isNotEmpty) {
        for(int i=0;i< value.length;i++) {
          DateModel  e=value.elementAt(i);
          DatesList.add(e);
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
      }
    });
  }

  void DatesData(){
    positioningDemoEvents.clear();
    DatesListUniq.forEach((e) {
      positioningDemoEvents.add(_DemoEvent(0, "", 1,
          DateTime.utc(e.year, e.month, e.day)+ const Duration(hours: 08, minutes: 40)
          ,DateTime.utc(e.year, e.month, e.day) + const Duration(hours: 21, minutes: 00)));

      positioningDemoEvents.add(_DemoEvent(0, "", 1,
          DateTime.utc(e.year, e.month, e.day)+ const Duration(hours: 08, minutes: 40)
          ,DateTime.utc(e.year, e.month, e.day)+ const Duration(hours: 21, minutes: 00)));

      positioningDemoEvents.add(_DemoEvent(0, "", 1,
          DateTime.utc(e.year, e.month, e.day)+ const Duration(hours: 08, minutes: 40)
          ,DateTime.utc(e.year, e.month, e.day) + Duration(hours: 21, minutes: 00)));

    });

    DatesList.forEach((e) {
      DateTime dateStart = DateTime.parse(e.dateStart);
      String direction='l';
      double scale=0.6;
      if(dateStart.hour>=15){
        direction='r';
        scale=0.4;
      }
      DateTime  dateStartYMD=DateTime.utc(dateStart.year, dateStart.month, dateStart.day);
      positioningDemoEvents.add(
          _DemoEvent.allDay(
              int.parse(e.doctorId) ,"${e.doctorName} ${e.place}",DateTime.utc(dateStartYMD.year, dateStartYMD.month, dateStartYMD.day).atStartOfDay,  scale: scale,direction:direction
          ));
    });
    allDatesList.forEach((element) {
      DateTime dateStart = DateTime.parse(element.dateStart);
      DateTime dateEnd = DateTime.parse(element.dateEnd);
      DateTime  dateStartYMD=DateTime.utc(dateStart.year, dateStart.month, dateStart.day);
      DateTime  dateEndYMD=DateTime.utc(dateEnd.year, dateEnd.month, dateEnd.day);
      int noOfclass=1;
      if(element.place=='غرفة 1'){
        noOfclass=2;
      }else if(element.place=='غرفة 2'){
        noOfclass=3;
      }else if(element.place=='غرفة 3'){
        noOfclass=4;
      }
      String title= ' ${element.costumerName} \n ${element.doctorName} \n ${element.note} \n ${element.place}';
      positioningDemoEvents.add(_DemoEvent(element.id,title, noOfclass,
          dateStartYMD+ Duration(hours: dateStart.hour, minutes: dateStart.minute)
          ,  dateEndYMD+ Duration(hours: dateEnd.hour, minutes: dateEnd.minute)));
    });
  }
}

enum PredefinedVisibleDateRange { day, threeDays,sevenDays, week  }

extension on PredefinedVisibleDateRange {
  VisibleDateRange get visibleDateRange {
    switch (this) {
      case PredefinedVisibleDateRange.day:
        return VisibleDateRange.days(1);
      case PredefinedVisibleDateRange.threeDays:
        return VisibleDateRange.days(3);
      case PredefinedVisibleDateRange.sevenDays:
        return VisibleDateRange.days(6);
      case PredefinedVisibleDateRange.week:
        return VisibleDateRange.week(startOfWeek: DateTime.saturday);
    }
  }

  String get title {
    switch (this) {
      case PredefinedVisibleDateRange.day:
        return 'يوم';
      case PredefinedVisibleDateRange.threeDays:
        return 'ثلاث أيام';
      case PredefinedVisibleDateRange.sevenDays:
        return ' سبع أيام';
      case PredefinedVisibleDateRange.week:
        return 'أسبوع';
    }
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

  _DemoEvent.allDay(int id,String title,
      DateTime start,
      {double scale=1,
        String direction='l'
      })
      : super(
    id: '$id',
    title: title,
    backgroundColor: _getColor(5, id:id),
    scale: scale ,
    direction:direction,
    start:start.atStartOfDay ,
    end: start.atStartOfDay+ 1.days ,
  );

  static Color _getColor(int classfication , {int id=0}) {
    if(classfication== 1){
      return Colors.white60;
    }else if(classfication== 2){// romm 1
      return const Color(0xFF87cc52);
    }else if(classfication== 3){// romm 2
      return Colors.pinkAccent;
    }else if(classfication== 4){// romm 3
      return const Color(0xFFcc52a5);
    }else if(classfication== 5) { // Doctors Dating
      if (id % 4 == 0) {
        return const Color(0xFF87cc52);
      } else if (id % 4 == 1) {
        return Colors.blue;
      }else if (id % 4 == 2) {
        return Colors.amberAccent;
      }else {
        return  Colors.deepPurple;
      }
    }else
    {
      return const Color(0xFFcc52a5);
    }
  }
}





List<TimeOverlay> positioningDemoOverlayProvider(
    BuildContext context,
    DateTime date,
    ) {
  assert(date.debugCheckIsValidTimetableDate());

  final widget = ColoredBox(
      color: context.theme.brightness.contrastColor.withOpacity(.1));

  if (date.weekday != DateTime.friday) {
    return [
      TimeOverlay(start: 0.hours, end: 9.hours, widget: widget),
      TimeOverlay(start: 21.hours, end: 24.hours, widget: widget),
    ];
  } else {
    return [TimeOverlay(start: 0.hours, end: 24.hours, widget: widget)];
  }
}


