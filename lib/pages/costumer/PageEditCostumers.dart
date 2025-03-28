import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hussam_clinc/db/patients/dbpatienthealthdoctor.dart';
import 'package:hussam_clinc/db/patients/dbpicture.dart';
import 'package:hussam_clinc/model/patients/PatientHealthDoctorModel.dart';
import 'package:intl/intl.dart' as tt;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../db/dbemployee.dart';
import '../../db/patients/dbpatient.dart';
import '../../db/patients/dbpatienthealth.dart';
import '../../global_var/globals.dart';
import '../../main.dart';
import '../../model/Employment/EmployeeModel.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/patients/PatientModel.dart';

class PageEditCostumers extends StatefulWidget {
  final PatientModel Patients;
  PageEditCostumers(this.Patients,{super.key});
  @override
  State<PageEditCostumers> createState() => _PageEditCostumersState();
}
DateTime projectStartDate = DateTime.now();

class _PageEditCostumersState extends State<PageEditCostumers> {
  List<PatienHealthtDoctorModel> allPHD = [];
  List<bool> PHD_edit=[];
  List<String> imageUrls=[];

  int paint_id=1;
  var _patient_name,  _patient_mobile,_patient_fileNo;
  var _patient_resone;
  var _patient_worries="نعم";
  var _patient_place, _patient_sex='ذكر';
  String _patient_birthDate= '${projectStartDate.day}/${projectStartDate.month}/${projectStartDate.year}';

  var _patient_status='أعزب';
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  GlobalKey<FormState> formstate2 = GlobalKey<FormState>();
  GlobalKey<FormState> formstate3 = GlobalKey<FormState>();
  late List<GlobalObjectKey<FormState>> formstateList = List.generate(0, (int  index) => GlobalObjectKey<FormState>(index), growable: true);
  final List<GlobalObjectKey<FormState>> formstateList2 = List.generate(5, (int  index) => GlobalObjectKey<FormState>(index), growable: true);

  var costumer_sex_items=[
    "ذكر",
    "أنثى",
  ];
  var costumer_status_items=[
    "متزوج",
    "أعزب",
    "أرمل",
  ];
  var costumer_worries_items=[
    "نعم",
    "لا",
    "نوعا ما",
  ];
  var _patient_health;
  var  _patient_sensitive=false,_patient_sensitive_Ex="";
  var _patient_surgical=false,_patient_surgical_Ex="";
  var _patient_haemophilia=false,_patient_haemophilia_Ex="";
  var _patient_drugs=false,_patient_drugs_Ex="";
  var _patient_oralDiseases,_patient_smoking=false;
  var _patient_pregnant=false,_patient_pregnant_Ex="";
  var _patient_lactating=false,_patient_lactating_Ex="";
  var _patient_contraception=false,_patient_contraception_Ex="";

  List<String> listDoctors = [];
  String _PHD_Date= '${projectStartDate.day}/${projectStartDate.month}/${projectStartDate.year}';
  String _PHD_DoctorList= '';
  String _PHD_DoctorID = "";
  String _PHD_treatment = "";
  String _PHD_diagnosis = "";

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'معلومات عامة'),
    Tab(text: 'معلومات صحية'),
    Tab(text: 'تفاصيل العلاج'),
    Tab(text: 'صور الأسنان'),
  ];

  bool editCheck=true;
  bool editCheckhealth=false;
  bool editCheckHealthDoctor=false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var numberFormat =tt.NumberFormat("00000", "en_US");
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;

  ButtonStyle FirstClick =ButtonStyle(
    backgroundColor:MaterialStateProperty.all<Color>(Colors.white),
    textStyle: MaterialStateProperty.all(
      const TextStyle(fontSize: 25,fontWeight:FontWeight.bold),
    ),
    fixedSize: MaterialStateProperty.all(const Size(280, 50)),
    side: MaterialStateProperty.all(
      const BorderSide(
        color: Colors.deepPurple,
        width: 2,
      ),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    alignment: Alignment.center,
  );
  ButtonStyle SecondClick =ButtonStyle(
    backgroundColor:MaterialStateProperty.all<Color>(Colors.white12),
    textStyle: MaterialStateProperty.all(
      const TextStyle(fontSize: 25,fontWeight:FontWeight.bold,color:Colors.white),
    ),
    fixedSize: MaterialStateProperty.all(const Size(280, 50)),
    side: MaterialStateProperty.all(
      const BorderSide(
        color: Colors.blueGrey,
        width: 2,
      ),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    alignment: Alignment.center,
  );

  editCostumers(context) async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      if(editCheck==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          action: SnackBarAction(
            textColor:Colors.white,
            backgroundColor:Colors.pinkAccent,
            label: 'تعديل البيانات الشخصية ',
            onPressed: () {
              DbPatient dbPatient = DbPatient();
              dbPatient.updateFileNoPatient(_patient_name,_patient_mobile,_patient_sex,_patient_status,
                  _patient_birthDate,_patient_fileNo,_patient_place,_patient_resone,_patient_worries);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  ' تم تعديل بيانات المريض بنجاح ',
                  style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                ),
                duration: Duration(seconds: 4),
              ));
              AllPatientList();
            },
          ),
          content: const Column(
            children: [
              Text(
                'لم يتم إضافة البيانات لأن البيانات مكررة يرجى مراجعة البيانات ',
                style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
        ));
        editCheck=false;
        AllPatientList();
      }
    }
  }
  editeCostumerhealth(context) async {
    var formdata = formstate2.currentState;
    if (formdata!.validate()) {
      formdata.save();
      for(int i =0;i<allPatient.length;i++)
      {
        var paint=allPatient[i];
        if( int.parse(paint.fileNo)== int.parse(_patient_fileNo)){
          editCheck=false;
          paint_id=paint.id;
          i= allPatient.length-1;
        }
      }
      if(editCheckhealth==false){
        DbPatientHealth dbPatientHealth = DbPatientHealth();
        dbPatientHealth.addPatientHealth(paint_id.toString(),_patient_health,
            _patient_sensitive.toString(), _patient_sensitive_Ex,
            _patient_surgical.toString(), _patient_surgical_Ex,
            _patient_haemophilia.toString(), _patient_haemophilia_Ex,
            _patient_oralDiseases, _patient_smoking.toString(),
            _patient_pregnant.toString(), _patient_pregnant_Ex,
            _patient_lactating.toString(), _patient_lactating_Ex,
            _patient_contraception.toString(), _patient_contraception_Ex
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            ' تم إضافة  البيانات الصحية للمريض بنجاح ',
            style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
          ),
          duration: Duration(seconds: 4),
        ));
        editCheckhealth=true;
        AllPatientList();
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          action: SnackBarAction(
            textColor:Colors.white,
            backgroundColor:Colors.pinkAccent,
            label: 'تعديل الملف ',
            onPressed: () {
              DbPatientHealth dbPatientHealth = DbPatientHealth();
              dbPatientHealth.addPatientHealth(paint_id.toString(),_patient_health,
                  _patient_sensitive.toString(), _patient_sensitive_Ex,
                  _patient_surgical.toString(), _patient_surgical_Ex,
                  _patient_haemophilia.toString(), _patient_haemophilia_Ex,
                  _patient_oralDiseases, _patient_smoking.toString(),
                  _patient_pregnant.toString(), _patient_pregnant_Ex,
                  _patient_lactating.toString(), _patient_lactating_Ex,
                  _patient_contraception.toString(), _patient_contraception_Ex
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  ' تم تعديل بيانات المريض بنجاح ',
                  style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                ),
                duration: Duration(seconds: 4),
              ));
              AllPatientList();
            },
          ),
          content: const Column(
            children: [
              Text(
                'لم يتم إضافة البيانات لأن البيانات مكررة يرجى مراجعة البيانات ',
                style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
        ));
      }
      AllPatientList();
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selecedDoctorList();
      intValues();
    });
  }
  void intValues(){
    setState(() {
      DbPatientHealth dbPatientHealth = DbPatientHealth();
      dbPatientHealth.allPHs().then((HPS) {
        for (var HP in HPS) {
          if(HP.patientId==widget.Patients.id.toString()){
            setState(() {
              _patient_health=HP.health;
              _patient_sensitive=bool.parse(HP.sensitive.toLowerCase());
              _patient_sensitive_Ex=HP.sensitive_Ex;
              _patient_surgical=bool.parse(HP.surgical.toLowerCase());
              _patient_surgical_Ex=HP.surgical_Ex;
              _patient_haemophilia=bool.parse(HP.haemophilia.toLowerCase());
              _patient_haemophilia_Ex=HP.haemophilia_Ex;
              _patient_drugs=bool.parse(HP.drugs.toLowerCase());
              _patient_drugs_Ex=HP.drugs_Ex;
              _patient_oralDiseases=HP.oralDiseases;
              _patient_smoking=bool.parse(HP.smoking.toLowerCase());
              _patient_pregnant=bool.parse(HP.pregnant.toLowerCase());
              _patient_pregnant_Ex=HP.pregnant_Ex;
              _patient_lactating=bool.parse(HP.lactating.toLowerCase());
              _patient_lactating_Ex=HP.lactating_Ex;
              _patient_contraception=bool.parse(HP.contraception.toLowerCase());
              _patient_contraception_Ex=HP.contraception_Ex;
            });
          }
        }
      });
    });
    DbPatientHealthDoctor dbPatientHealthDoctor = DbPatientHealthDoctor();
    setState(() {
      dbPatientHealthDoctor.searchByPatientId(widget.Patients.id).then((value) {
        allPHD.addAll(value);
        for(int i=0;i<allPHD.length;i++){
          PHD_edit.add(false);
        }
      });
      paint_id=widget.Patients.id;
      _patient_name=widget.Patients.name.toString();
      _patient_mobile=widget.Patients.mobile.toString();
      _patient_fileNo=widget.Patients.fileNo.toString();
      _patient_resone=widget.Patients.resone.toString();
      _patient_worries="لا";
      _patient_place=widget.Patients.address.toString();
      _patient_sex=widget.Patients.sex.toString()=='M'||widget.Patients.sex.toString()==''? 'ذكر':widget.Patients.sex.toString();
      //(widget.Patients.birthDay.isEmpty || widget.Patients.birthDay=='')?print('widget.Patients.birthDay'):print('rrrrrrrrrrrrrrffffffrr===${widget.Patients.birthDay}   ');
      projectStartDate =(widget.Patients.birthDay.isEmpty || widget.Patients.birthDay=='null')? projectStartDate:tt.DateFormat("dd/MM/yyyy").parse(widget.Patients.birthDay);
      _patient_birthDate=widget.Patients.birthDay.toString()==''?'${projectStartDate.day}/${projectStartDate.month}/${projectStartDate.year}':widget.Patients.birthDay.toString();
      _patient_status='أعزب';

      /// find Max No of Picture
      DbPicture dbPicture = DbPicture();
      dbPicture.lastPicture();
      dbPicture.searchPictureByPatientId(widget.Patients.id.toString()).then((picList) =>
          picList.forEach((pic) {
            setState(() {
              imageUrls.add(pic.pictureLocation);
            });

          })
      ) ;
    });
  }

  InputDecoration inputDecoration (IconData icon,String hintText) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 35),
      hintText:hintText,
      filled:true,
      fillColor:Colors.white,
      hintStyle: const TextStyle(fontSize: 20),
      errorStyle: const TextStyle(color:Colors.yellow,fontSize: 15,fontWeight: FontWeight.bold),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 3, color: Colors.white),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            width: 4, color: Color(0xffF02E65)),
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1)),
    );
  }
  InputDecoration inputDecorationNoIcon (String hintText) {
    return InputDecoration(
      hintText:hintText,
      filled:true,
      fillColor:Colors.white,
      hintStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
      errorStyle: const TextStyle(color:Colors.yellow,fontSize: 15,fontWeight: FontWeight.bold),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 3, color: Colors.white),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            width: 4, color: Color(0xffF02E65)),
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          key:_scaffoldKey,
          backgroundColor:Color(0xFF1D9D99),
          appBar: AppBar(
            title: const Text('تعديل بيانات المرضى',
                style:TextStyle(color:Colors.white)),
            backgroundColor:const Color(0xFF167774),
            bottom: const TabBar(
              tabs: myTabs,
              labelStyle:TextStyle(fontSize:16,fontWeight:FontWeight.bold),
              labelColor:Colors.white,
              unselectedLabelStyle:TextStyle(fontSize:16,fontWeight:FontWeight.normal),
              unselectedLabelColor:Colors.grey,
              dividerColor:Colors.black,
              indicatorColor:Colors.pink,
              indicatorWeight:3,
            ),
          ),
          body: TabBarView(
            // controller:_tabController,
            // clipBehavior: Clip.hardEdge,
            children: [
              Container(
                child: FisrtPage(context),
              ),
              Container(
                child:SecondPage(context),
              ),
              Container(
                  child: ThirdPage(context)
              ),
              Container(
                  child: FourPage(context)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget FisrtPage(BuildContext context){
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Form(
            key: formstate,
            child: Column(
              children: [
                const SizedBox(height: 20,),
                // PaintFileNo and PaintName
                Row(
                  children: [
                    Flexible(
                      flex : 2,
                      fit: FlexFit.tight,
                      child:
                      TextFormField(
                        initialValue:widget.Patients.fileNo,
                        readOnly:true,
                        style: const TextStyle(fontSize: 20),
                        decoration:inputDecoration(Icons.filter_1,"رقم الملف"),
                      ),
                    ),
                    const SizedBox(width: 7,),
                    Flexible(
                      flex : 6,
                      child:
                      TextFormField(
                        initialValue:widget.Patients.name,
                        onChanged:(val) {
                          setState(() {
                            editCheck=true;
                          });
                        },
                        onSaved: (val) {
                          _patient_name = val;
                        },
                        validator: (val) {
                          if (val!.length > 50) {
                            return "يجب أن يكون اسم المستخدم أقل من 50 حرف";
                          }
                          if (val.length < 3) {
                            return "يجب أن يكون اسم المستخدم أكثر من تلاث حروف";
                          }
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\d+[,.]{0,1}[0-9]*')),
                          FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z0-9]')),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(fontSize: 20),
                        decoration:inputDecoration(Icons.person,"اسم المريض"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                // Sex and mobileNumber
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex : 3,
                      child:
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        height: 70.0,
                        decoration: BoxDecoration(
                          color:Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButton(
                          value:_patient_sex,
                          hint: const Text('الجنس'),
                          underline: const SizedBox(),
                          icon: const Icon(Icons.arrow_downward),
                          isExpanded:true,
                          selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
                            return costumer_sex_items
                                .map((String value) {
                              return Center(
                                child: Text(
                                  _patient_sex,
                                  style: const TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList();
                          },
                          // Array list of items
                          items: costumer_sex_items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Center(
                                child: Text(items,
                                  style: const TextStyle(color: Colors.black, fontSize: 20),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (Object? value) {
                            setState(() {
                              _patient_sex=value.toString();
                              editCheck=true;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Flexible(
                      flex : 5,
                      child: TextFormField(
                        initialValue:widget.Patients.mobile,
                        validator: (val) {
                          if (val!.length > 10) {
                            return "لا يكون الاسم أكثر من 10 حرفا";
                          }
                          if (val.length < 10) {
                            return "لا يكون الاسم أقل من 10 أحرف";
                          }
                          return null;
                        },
                        onChanged:(val) {
                          setState(() {
                            editCheck=true;
                          });
                        },
                        onSaved: (val) {
                          setState(() {
                            _patient_mobile = val;
                          });
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'\d')),
                        ],
                        // validate after each user interaction
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(fontSize: 18),
                        decoration: inputDecoration(Icons.mobile_friendly,"رقم الجوال "),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                // Paint Place
                TextFormField(
                  initialValue:widget.Patients.address,
                  validator: (val) {
                    if (val!.length > 50) {
                      return " يجب أن لا يكون الاسم أكثر من 50 حرفا";
                    }
                    if (val.length < 4) {
                      return " يجب أن لا يكون الاسم أقل من 4 أحرف";
                    }
                  },
                  onChanged:(val) {
                    setState(() {
                      editCheck=true;
                    });
                  },
                  onSaved: (val) {
                    _patient_place = val;
                  },
                  // keyboardType: const TextInputType.numberWithOptions()
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]'))
                  ],
                  // validate after each user interaction
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(fontSize: 20),
                  decoration:inputDecoration(Icons.place,"عنوان المريض"),
                ),
                const SizedBox(height: 20,),
                // Staus  and PaintBirthDate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex : 3,
                      child:
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        height: 70.0,
                        decoration: BoxDecoration(
                          color:Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButton(
                          // Initial Value
                          value:_patient_status,
                          hint: const Text('الحالة الاجتماعية'),
                          underline: const SizedBox(),
                          icon: const Icon(Icons.arrow_downward),
                          isExpanded:true,
                          selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
                            return costumer_status_items
                                .map((String value) {
                              return Center(
                                child: Text(
                                  _patient_status,
                                  style: const TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList();
                          },
                          // Array list of items
                          items: costumer_status_items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Center(
                                child: Text(items,
                                  style: const TextStyle(color: Colors.black, fontSize: 20),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (Object? value) {
                            setState(() {
                              _patient_status=value.toString();
                              editCheck=true;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Flexible(
                      flex : 5,
                      child:
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 2,color: Colors.grey,),
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                          ),
                          child:  Column(
                            children: [
                              const Text(' تاريخ الميلاد',style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold )),
                              const Divider(thickness: 2,),
                              TextButton(
                                onPressed: () async {
                                  final date = await pickDate(context);
                                  if (date == null) return;
                                  setState(() {
                                    _patient_birthDate =  '${date.day}/${date.month}/${date.year}';
                                    //projectStartDate=date;
                                    editCheck=true;
                                  } );
                                  // print(date);
                                },
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_month, size:30,),
                                      Text(
                                        '   ${projectStartDate.year}/${projectStartDate.month}/${projectStartDate.day}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2,),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                // Paint Resone
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex : 5,
                      child:
                      TextFormField(
                        initialValue:widget.Patients.resone,
                        onChanged:(val) {
                          setState(() {
                            editCheck=true;
                          });
                        },
                        onSaved: (val) {
                          _patient_resone = val;
                        },
                        // keyboardType: const TextInputType.numberWithOptions()
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]'))
                        ],
                        style: const TextStyle(fontSize: 20),
                        decoration:inputDecoration(Icons.report_problem_outlined," السبب الرئيسي لزيارة المريض"),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Flexible(
                      flex : 2,
                      child:
                      Container(
                          height:120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 2,color: Colors.grey,),
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                          ),
                          child:  Column(
                            children: [
                              const Text('هل تقلقك زيارة طبيب الأسنان',style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold )),
                              const Divider(thickness: 1,),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                height: 60.0,
                                child:DropdownButton(
                                  // Initial Value
                                  value:_patient_worries,
                                  hint: const Text('هل يقلقك زيارة الطبيب'),
                                  underline: const SizedBox(),
                                  icon: const Icon(Icons.arrow_downward),
                                  isExpanded:true,
                                  selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
                                    return costumer_worries_items
                                        .map((String value) {
                                      return Center(
                                        child: Text(
                                          _patient_worries,
                                          style: const TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  // Array list of items
                                  items: costumer_worries_items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Center(
                                        child: Text(items,
                                          style: const TextStyle(color: Colors.black, fontSize: 20),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (Object? value) {
                                    setState(() {
                                      _patient_worries=value.toString();
                                      editCheck=true;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 2,),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Center(
                  child: TextButton(
                      onPressed: (){
                        setState(() {
                          editCostumers(context);
                        });
                      },
                      style:editCheck==false?SecondClick:FirstClick,
                      child:
                      const Row(
                        mainAxisAlignment : MainAxisAlignment.center,
                        children: [
                          Text('تعديل بيانات المريض',style: TextStyle(color:Color(0xFF167774),fontSize: 20),),
                          Icon(Icons.save_outlined,color: Color(0xFF167774),),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ) ;
  }
  Widget SecondPage(BuildContext context){
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Form(
            key: formstate2,
            child: Column(
              children: [
                const SizedBox(height: 15,),
                // _patient_health
                /** اذكر المشاكل الصحية **/
                TextFormField(
                  maxLines:2,
                  initialValue:_patient_health,
                  onChanged:(val) {
                    setState(() {
                      editCheckhealth=true;
                    });
                  },
                  onSaved: (val) {
                    _patient_health = val!;
                  },
                  style: const TextStyle(fontSize: 20),
                  decoration: inputDecorationNoIcon("اذكر أي مشاكل صحية"),
                ),
                const SizedBox(height: 15,),
                /** الحساسية في الجسم **/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex : _patient_sensitive==true?2:7,
                      child:
                      Container(
                        height:70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2,color: Colors.grey,),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment :_patient_sensitive==true? MainAxisAlignment.spaceBetween: MainAxisAlignment.spaceEvenly ,
                          children: [
                            const Text('هل تعاني من حساسية الجسم لأي دواء',style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold )),
                            const Divider(thickness: 2,),
                            Checkbox(
                              value: _patient_sensitive,
                              onChanged: (bool? value) {
                                setState(() {
                                  _patient_sensitive = value!;
                                  editCheckhealth=true;
                                });
                              },
                            ),
                            const SizedBox(height: 2,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4,),
                    Flexible(
                      flex : _patient_sensitive==true?2:1,
                      child:_patient_sensitive==true? TextFormField(
                        initialValue:_patient_sensitive_Ex ,
                        onChanged: (val) {
                          editCheckhealth=true;
                        },
                        onSaved: (val) {
                          _patient_sensitive_Ex = val!;
                        },
                        style: const TextStyle(fontSize: 18),
                        decoration: inputDecorationNoIcon("أذكرها.... "),
                      ):const Text(''),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                /** عمليات جراحية **/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex : _patient_surgical==true?2:7,
                      child:
                      Container(
                        height:70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2,color: Colors.grey,),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment :_patient_surgical==true? MainAxisAlignment.spaceBetween: MainAxisAlignment.spaceEvenly ,
                          children: [
                            const Text('هل خضعت لعمليات جراحية',style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold )),
                            const Divider(thickness: 2,),
                            Checkbox(
                              value: _patient_surgical,
                              onChanged: (bool? value) {
                                setState(() {
                                  _patient_surgical = value!;
                                  editCheckhealth=true;
                                });
                              },
                            ),
                            const SizedBox(height: 2,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4,),
                    Flexible(
                      flex : _patient_surgical==true?2:1,
                      child:_patient_surgical==true? TextFormField(
                        initialValue:_patient_surgical_Ex ,
                        onChanged: (val) {
                          editCheckhealth=true;
                        },
                        onSaved: (val) {
                          _patient_surgical_Ex = val!;
                        },
                        style: const TextStyle(fontSize: 18),
                        decoration: inputDecorationNoIcon("أذكرها.... "),
                      ):const Text(''),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                /** مخثرات الدم أو مضادات التخثر   **/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex : _patient_haemophilia==true?3:7,
                      child:
                      Container(
                        height:70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2,color: Colors.grey,),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment :_patient_haemophilia==true? MainAxisAlignment.spaceBetween: MainAxisAlignment.spaceEvenly ,
                          children: [
                            const Text('هل تأخذ علاج السيولة الدم أو مضادات التخثر',softWrap:true, maxLines:2,style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold )),
                            const Divider(thickness: 1,),
                            Checkbox(
                              value: _patient_haemophilia,
                              onChanged: (bool? value) {
                                setState(() {
                                  _patient_haemophilia = value!;
                                  editCheckhealth=true;
                                });
                              },
                            ),
                            const SizedBox(height: 2,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4,),
                    Flexible(
                      flex : _patient_haemophilia==true?2:1,
                      child:_patient_haemophilia==true? TextFormField(
                        initialValue:_patient_haemophilia_Ex ,
                        onChanged: (val) {
                          editCheckhealth=true;
                        },
                        onSaved: (val) {
                          _patient_haemophilia_Ex = val!;
                        },
                        style: const TextStyle(fontSize: 18),
                        decoration: inputDecorationNoIcon("أذكرها.... "),
                      ):const Text(''),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                /** أدوية علاجية **/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex : _patient_drugs==true?2:7,
                      child:
                      Container(
                        height:70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2,color: Colors.grey,),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment :_patient_drugs==true? MainAxisAlignment.spaceBetween: MainAxisAlignment.spaceEvenly ,
                          children: [
                            const Text('هل تتناول أدوية علاجية',softWrap:true, maxLines:2,style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold )),
                            const Divider(thickness: 1,),
                            Checkbox(
                              value: _patient_drugs,
                              onChanged: (bool? value) {
                                setState(() {
                                  _patient_drugs = value!;
                                  editCheckhealth=true;
                                });
                              },
                            ),
                            const SizedBox(height: 2,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4,),
                    Flexible(
                      flex : _patient_drugs==true?2:1,
                      child:_patient_drugs==true? TextFormField(
                        initialValue:_patient_drugs_Ex ,
                        onChanged: (val) {
                          editCheckhealth=true;
                        },
                        onSaved: (val) {
                          _patient_drugs_Ex = val!;
                        },
                        style: const TextStyle(fontSize: 18),
                        decoration: inputDecorationNoIcon("أذكرها.... "),
                      ):const Text(''),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                /**  مدخن     اذكر المشاكل الفموية  **/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex :3,
                      child: TextFormField(
                        maxLines:2,
                        initialValue:_patient_oralDiseases,
                        onChanged: (val) {
                          editCheckhealth=true;
                        },
                        onSaved: (val) {
                          _patient_oralDiseases = val!;
                        },
                        style: const TextStyle(fontSize: 20),
                        decoration: inputDecorationNoIcon("اذكر أي مشاكل فموية"),
                      ),
                    ),
                    const SizedBox(width: 3,),
                    Flexible(
                      flex :1,
                      child:
                      Container(
                        height:70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2,color: Colors.grey,),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment : MainAxisAlignment.spaceEvenly ,
                          children: [
                            const Text('هل أنت مدخن',softWrap:true, maxLines:2,style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold )),
                            const Divider(thickness: 1,),
                            Checkbox(
                              value: _patient_smoking,
                              onChanged: (bool? value) {
                                setState(() {
                                  _patient_smoking = value!;
                                  editCheckhealth=true;
                                });
                              },
                            ),
                            const SizedBox(height: 2,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                /** حامل **/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex : _patient_pregnant==true?1:7,
                      child:
                      Container(
                        height:70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2,color: Colors.grey,),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment : MainAxisAlignment.spaceEvenly ,
                          children: [
                            const Text('هل أنت حامل',softWrap:true, maxLines:2,style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold )),
                            const Divider(thickness: 1,),
                            Checkbox(
                              value: _patient_pregnant,
                              onChanged: (bool? value) {
                                setState(() {
                                  _patient_pregnant = value!;
                                  editCheckhealth=true;
                                });
                              },
                            ),
                            const SizedBox(height: 2,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4,),
                    Flexible(
                      flex : _patient_pregnant==true?2:1,
                      child:_patient_pregnant==true? TextFormField(
                        initialValue:_patient_pregnant_Ex,
                        onChanged: (val) {
                          editCheckhealth=true;
                        },
                        onSaved: (val) {
                          _patient_pregnant_Ex = val!;
                        },
                        style: const TextStyle(fontSize: 18),
                        decoration: inputDecorationNoIcon(" في أي شهر .... "),
                      ):const Text(''),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                /** مرضعة **/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex : _patient_lactating==true?1:7,
                      child:
                      Container(
                        height:70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2,color: Colors.grey,),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment : MainAxisAlignment.spaceEvenly ,
                          children: [
                            const Text('هل أنت مرضعة',softWrap:true, maxLines:2,style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold )),
                            const Divider(thickness: 1,),
                            Checkbox(
                              value: _patient_lactating,
                              onChanged: (bool? value) {
                                setState(() {
                                  _patient_lactating = value!;
                                  editCheckhealth=true;
                                });
                              },
                            ),
                            const SizedBox(height: 2,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4,),
                    Flexible(
                      flex : _patient_lactating==true?2:1,
                      child:_patient_lactating==true? TextFormField(
                        initialValue:_patient_lactating_Ex,
                        onChanged: (val) {
                          editCheckhealth=true;
                        },
                        onSaved: (val) {
                          _patient_lactating_Ex = val!;
                        },
                        style: const TextStyle(fontSize: 18),
                        decoration: inputDecorationNoIcon("عمر الرضيع .... "),
                      ):const Text(''),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                /** أدوية منع حمل  **/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex : _patient_contraception==true?1:7,
                      child:
                      Container(
                        height:70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2,color: Colors.grey,),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment : MainAxisAlignment.spaceEvenly ,
                          children: [
                            const Text('هل تأخذ أدوية منع حمل ',softWrap:true, maxLines:2,style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold )),
                            const Divider(thickness: 1,),
                            Checkbox(
                              value: _patient_contraception,
                              onChanged: (bool? value) {
                                setState(() {
                                  _patient_contraception = value!;
                                  editCheckhealth=true;
                                });
                              },
                            ),
                            const SizedBox(height: 2,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4,),
                    Flexible(
                      flex : _patient_contraception==true?2:1,
                      child:_patient_contraception==true? TextFormField(
                        initialValue:_patient_contraception_Ex,
                        onChanged: (val) {
                          editCheckhealth=true;
                        },
                        onSaved: (val) {
                          _patient_contraception_Ex = val!;
                        },
                        style: const TextStyle(fontSize: 18),
                        decoration: inputDecorationNoIcon("اذكريها  .... "),
                      ):const Text(''),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Center(
                  child: TextButton(
                      onPressed: (){
                        setState(() {
                          if (editCheck==false){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                'لم يتم إضافة البيانات الصحية يجب اضافة المعلومات الشخصية أولا  ',
                                style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                              ),
                              duration: Duration(seconds: 4),
                            ));
                          }else{
                            if (editCheckhealth==false){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                  ' تم إضافة البيانات الصحية',
                                  style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                                ),
                                duration: Duration(seconds: 4),
                              ));
                              editCheckhealth=true;
                            }else{
                              editeCostumerhealth(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                  'لم يتم إضافة البيانات الصحية هل تريد تعديل البينات',
                                  style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
                                ),
                                duration: Duration(seconds: 4),
                              ));
                            }
                          }
                        });
                      },
                      style:editCheckhealth==true?FirstClick:SecondClick,
                      child:
                      const Row(
                        mainAxisAlignment : MainAxisAlignment.center,
                        children: [
                          Text(' احفظ البيانات الصحية ',style: TextStyle(color:Color(0xFF167774),fontSize: 20),),
                          Icon(Icons.save_outlined,color: Color(0xFF167774),),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ) ;
  }
  Widget ThirdPage(BuildContext context){
    setState(() {
      allPHD.sort((a, b) => tt.DateFormat("dd/MM/yyyy").parse(b.date).compareTo(tt.DateFormat("dd/MM/yyyy").parse(a.date)));
      for (var element in PHD_edit) {element=false;}
    });
    return
      Directionality(
          textDirection: TextDirection.rtl,
          child:
          Scaffold(
              backgroundColor:Color(0xFF1D9D99),
              floatingActionButtonLocation:FloatingActionButtonLocation.startFloat,
              floatingActionButton: FloatingActionButton(
                  backgroundColor:Colors.white,
                  elevation: 15,
                  child:const Icon ( Icons.add_sharp,
                    color: Color(0xFF1D9D99),
                    size: 40.0,
                    semanticLabel: 'إضافة تفاصيل للعلاج',
                  ),
                  onPressed: () {
                    PatienHealthtDoctorModel PHD = PatienHealthtDoctorModel
                        .fromMap(
                        {
                          'PHD_id': 1,
                          "PHD_patientId": widget.Patients.id,
                          "PHD_doctorId": '1',
                          "PHD_doctorName": 'حسام العايدي',
                          "PHD_date": '${projectStartDate.day}/${projectStartDate
                              .month}/${projectStartDate.year}',
                          "PHD_treatment": '',
                          "PHD_diagnosis": '',
                        });
                    DbPatientHealthDoctor dbPatientHealthDoctor = DbPatientHealthDoctor();
                    dbPatientHealthDoctor.addPHD(
                        widget.Patients.id.toString(),
                        '1',
                        'حسام العايدي',
                        '${projectStartDate.day}/${projectStartDate
                            .month}/${projectStartDate.year}',
                        '',
                        ''
                    );
                    // allPHD.clear();
                    setState(() {
                      allPHD.add(PHD);
                      PHD_edit.add(false);

                      // allPHD.sort((a, b) => tt.DateFormat("dd/MM/yyyy").parse(b.date).compareTo(tt.DateFormat("dd/MM/yyyy").parse(a.date)));
                    });

                    //   setState(() {
                    //     dbPatientHealthDoctor.searchByPatientId(widget.Patients.id)
                    //         .then((value) {
                    //       allPHD.addAll(value);
                    //       for (int i = 0; i < allPHD.length; i++) {
                    //         PHD_edit.add(false);
                    //       }
                    //     });
                    //   });
                  }
              ),
              body:
              RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  updatePHD();
                },
                child:  CardView(),
              )
          )
      );
  }
  updatePHD (){
    setState(() {
      allPHD.clear();
      DbPatientHealthDoctor dbPatientHealthDoctor = DbPatientHealthDoctor();
      dbPatientHealthDoctor.searchByPatientId(widget.Patients.id)
          .then((value) {
        allPHD.addAll(value);
        for (int i = 0; i < allPHD.length; i++) {
          PHD_edit.add(false);
        }
      });
    });
  }
  Widget CardView() {
    setState(() {
      allPHD.sort((a, b) => tt.DateFormat("dd/MM/yyyy").parse(b.date).compareTo(tt.DateFormat("dd/MM/yyyy").parse(a.date)));
    });
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: allPHD.length,
        itemBuilder: (context, i) {
          PatienHealthtDoctorModel PHD = allPHD[i];
          _PHD_diagnosis=PHD.diagnosis;
          _PHD_treatment=PHD.treatment;
          if (listDoctors.isNotEmpty){
            _PHD_DoctorList =listDoctors.contains(PHD.doctorName)?PHD.doctorName:listDoctors[0];
            selecedDoctorId (_PHD_DoctorList);
            formstateList = List.generate(allPHD.length, (int  index) => GlobalObjectKey<FormState>(index), growable: true);
          }
          return Container(
            height:285,
            margin:const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white70,
              border: Border.all(width: 2,color: Colors.yellow,),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: Form(
              key: formstateList.elementAt(i),
              onChanged:(){
                PHD_edit[i]=true;
              } ,
              child:
              Column(
                children: [
                  const SizedBox(height: 7,),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,right: 8),
                    child: Row(
                      children: [
                        Flexible(
                          flex : 2,
                          child:
                          Container(
                            height:75,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 2,color: Colors.purpleAccent,),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child:Center(
                              child:
                              TextButton(
                                onPressed: () async {
                                  final date = await pickDate(context);
                                  if (date == null) return;
                                  setState(() {
                                    _PHD_Date = '${date.day}/${date.month}/${date.year}';
                                    //DateTime PHDDate = tt.DateFormat("dd/MM/yyyy").parse(PHD.date);
                                    allPHD[i].date='${date.day}/${date.month}/${date.year}';
                                    editCheckHealthDoctor=true;
                                  } );
                                  // print(date);
                                },
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_month, size:30,),
                                      Text(
                                        allPHD[i].date,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Flexible(
                          flex : 2,
                          child:
                          DropdownButtonFormField(
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
                            value: _PHD_DoctorList,
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
                              _PHD_DoctorList = val as String;
                              allPHD[i].doctorName= val ;
                              selecedDoctorId (_PHD_DoctorList);
                              allPHD[i].doctorId= _PHD_DoctorID;
                            },
                          ),
                        ),
                        const SizedBox(width: 2,),
                        Flexible(
                          flex : 1,
                          child:
                          Center(
                            child: IconButton (icon:
                            Icon(
                                Icons.save,
                                size: 35,
                                color:PHD_edit[i]==false ?Colors.black:Colors.green
                            ),
                              onPressed: () {
                                PatienHealthtDoctorModel patienHealthtDoctorModel  = PatienHealthtDoctorModel.name();
                                DbPatientHealthDoctor dbPatientHealthDoctor = DbPatientHealthDoctor();
                                patienHealthtDoctorModel.id=allPHD[i].id;
                                patienHealthtDoctorModel.date=allPHD[i].date;
                                patienHealthtDoctorModel.patientId=widget.Patients.id.toString();
                                patienHealthtDoctorModel.doctorName=allPHD[i].doctorName;
                                patienHealthtDoctorModel.diagnosis=allPHD[i].diagnosis;//_PHD_diagnosis;
                                patienHealthtDoctorModel.treatment=allPHD[i].treatment;//_PHD_treatment;
                                patienHealthtDoctorModel.doctorId=allPHD[i].doctorId;
                                //print('ioioioioio==== ${allPHD[i].id}');
                                dbPatientHealthDoctor.updatePHD(allPHD[i].id,patienHealthtDoctorModel);
                                PHD_edit[i]=false;
                              },),
                          ),
                        ),
                        const SizedBox(width: 2,),
                        Flexible(
                          flex : 1,
                          child:
                          Center(
                            child: IconButton
                              (icon: const Icon(Icons.delete_forever_outlined, size: 35,color:Colors.red ,),
                              onPressed: () {
                                setState(() async {
                                  await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('هل أنت متأكد من حذف  تفاصيل العلاج لهذا المريض'),
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
                                                  DbPatientHealthDoctor dbPatientHealthDoctor = DbPatientHealthDoctor();
                                                  dbPatientHealthDoctor.deletePHD(allPHD[i].id);
                                                  allPHD.removeAt(i);
                                                  PHD_edit.removeAt(i);
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
                                      });
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,right: 8),
                    child: Container(
                      height:110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2,color: Colors.purpleAccent,),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines:2,
                          initialValue: allPHD[i].diagnosis,
                          onChanged:(val) {
                            allPHD[i].diagnosis = val!;
                            _PHD_diagnosis= val!;
                          },
                          onSaved: (val) {
                            allPHD[i].diagnosis = val!;
                            _PHD_diagnosis= val!;
                          },
                          style: const TextStyle(fontSize: 20),
                          decoration: inputDecorationNoIcon("التشخيص"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,right: 8),
                    child: Container(
                      height:70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2,color: Colors.purpleAccent,),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines:1,
                          initialValue: allPHD[i].treatment,
                          onChanged:(val) {
                            setState(() {
                              allPHD[i].treatment = val!;
                              editCheckhealth=true;
                              _PHD_treatment = val!;
                            });
                          },
                          onSaved: (val) {
                            _PHD_treatment = val!;
                            allPHD[i].treatment = val!;
                          },
                          style: const TextStyle(fontSize: 20),
                          decoration: inputDecorationNoIcon("العلاج"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                ],
              ),
            ),
          );
        });
  }

  Widget FourPage(BuildContext context){
    return
      Directionality(
        textDirection: TextDirection.rtl,
        child:
        Scaffold(
          backgroundColor:Color(0xFF1D9D99),
          floatingActionButtonLocation:FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor:Colors.white,
            elevation: 15,
            child:const Icon ( Icons.add_sharp,
              color: Color(0xFF1D9D99),
              size: 40.0,
              semanticLabel: 'إضافة الصور ',
            ),
            onPressed: () {
              AddSelectpic();
            },
          ),
          body:imageUrls.isEmpty?const Center(child: Text('لا يوجد صور في المعرض',style: TextStyle(fontSize: 20,color:Colors.white ),)): photoGallery(),
        ),
      );
  }

  Future<void> AddSelectpic(){
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          width:double.infinity,
          color: Colors.white,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(''
                    'اختر مكان الصورة '),
                ElevatedButton(
                    onPressed: () {
                      imageSelector(
                          context,
                          "camera",
                          "Patient_${numberFormat.format(widget.Patients.id)}_${numberFormat.format(int.parse(maxNoPic))}.jpg",
                          widget.Patients.id);
                      imageUrls.add( "Patient_${numberFormat.format(widget.Patients.id)}_${numberFormat.format(int.parse(maxNoPic))}.jpg");
                    },
                    child: const Text("الكاميرا")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      imageSelector(
                          context,
                          "gallery",
                          "Patient_${numberFormat.format(widget.Patients.id)}_${numberFormat.format(int.parse(maxNoPic))}.jpg",
                          widget.Patients.id);
                      imageUrls.add( "Patient_${numberFormat.format(widget.Patients.id)}_${numberFormat.format(int.parse(maxNoPic))}.jpg");
                    }
                    , child: const Text("استيديو الصور")),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget photoGallery() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        child: PhotoViewGallery.builder(
          itemCount: imageUrls.length,
          backgroundDecoration: const BoxDecoration(
            color:Color(0xFF1D9D99),
          ),
          scrollDirection: Axis.horizontal,
          //scrollPhysics: const BouncingScrollPhysics(),
          builder: (context, index) {
            listenForPermissionStatus();
            return setPhoto(index, imageUrls[index]);
          },
        ),
      ),
    );
  }
  PhotoViewGalleryPageOptions? photoViewGalleryPageOption;
  PhotoViewGalleryPageOptions setPhoto(int index, String picPath) {
    listenForPermissionStatus();
    if (isPermmission || imageUrls.isNotEmpty) {
      Image img = Image.file(File(picPath));
      return PhotoViewGalleryPageOptions(
        imageProvider: img!.image,
        initialScale: PhotoViewComputedScale.contained,
        onScaleEnd: (context, details, controllerValue) {

        },
        onTapDown:(context, details, controllerValue) {
          DeletPic( index);
        },
        onTapUp: (context, details, controllerValue) {
          DeletPic( index);
        },
      );
    } else {
      // print("put the icons");
      return PhotoViewGalleryPageOptions(
        imageProvider: const AssetImage('assets/icon/buildings.png'),
        initialScale: PhotoViewComputedScale.contained,
      );
    }
  }
  void DeletPic(int index){
    setState(() {
      // print('object   Delte');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
          textColor:Colors.white,
          backgroundColor:Colors.pinkAccent,
          label: ' هل تريد الحذف بالفعل ',
          onPressed: () {
            DbPicture dbPicture = DbPicture();
            dbPicture.deletePicture(imageUrls[index]);
            imageUrls.remove(imageUrls[index]);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                ' تم حذف الصورة بنجاح ',
                style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
              ),
              duration: Duration(seconds: 2),
            ));

          },
        ),
        content: const Column(
          children: [
            Text(
              'لم يتم حذف الصورة  ',
              style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ));
    });
  }
  bool isPermmission = false;
  listenForPermissionStatus() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      isPermmission = true;
      //print("Permission is true");
    } else {
      isPermmission = false;
      // print("Permission is false");
      listenForPermissionStatus();
    }
  }


  Widget showPicturs(){
    listenForPermissionStatus();
    return  Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("اضغظ لفتح الصورة",style:TextStyle(fontSize: 20,color: Colors.white) ,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GalleryImage(
                  numOfShowImages:imageUrls.length<9?imageUrls.length:9 ,
                  titleGallery:'صور الأسنان',
                  imageUrls:imageUrls
              ),
            ),
          ],
        ),
      ),
    );
  }


//********************** IMAGE PICKER
  Future imageSelector(BuildContext context, String pickerType, String picName,
      int projectId) async {
    switch (pickerType) {
      case "gallery": // GALLERY IMAGE PICKER
        imageFile = await picker.pickImage(
            source: ImageSource.gallery, imageQuality: 100);
        break;
      case "camera": // CAMERA CAPTURE CODE
      // ignore: unnecessary_cast
        imageFile = await picker.pickImage(
            source: ImageSource.camera, imageQuality: 100);
        break;
    }
    if (imageFile != null) {
      PermissionStatus status2 =
      await Permission.manageExternalStorage.request();
      if (status2.isGranted) {
        await imageFile!.saveTo('$extPicFolder/$picName');
      }
      /// find Max No of Picture
      DbPicture dbPicture = DbPicture();
      dbPicture.lastPicture();
      /// add pic to Data Base
      dbPicture.addPicture("$extPicFolder/$picName", projectId.toString());
      // List yt = itemsPicture[projectId];
      // yt.add("$extPicFolder/$picName");
      // itemsPicture[projectId] = yt;
    } else {
      // print("You have not taken image");
    }
  }

  Future<void> selecedDoctorId(String name) async {
    DbEmployee dbEmployee = DbEmployee();
    dbEmployee.searchingEmployee(name).then((Employees) {
      Employees!.then((Employee) {
        for (var item in Employee) {
          if (mounted) {
            setState(() {
              EmployeeModel doctor = EmployeeModel.fromMap(item);
              _PHD_DoctorID=doctor.id.toString();
            });
          }
        }
      });
    });
  }
  void selecedDoctorList()  {
    DbEmployee dbEmployee = DbEmployee();
    dbEmployee.allEmployeesM().then((employees) {
      for (var doctor in employees) {
        if (doctor.jop=='دكتور'){
          setState(() {
            listDoctors.add(doctor.name.toString());
            //print('ddddddddddddddddddddddddddddd=========  ${doctor.name}');
          });
        }
      }
    });
  }

  Future<DateTime?> pickDate(context) {
    return showDatePicker(
      context: context,
      initialDate: projectStartDate,
      firstDate: DateTime(1930),
      lastDate: DateTime(2520),
    );
  }
}