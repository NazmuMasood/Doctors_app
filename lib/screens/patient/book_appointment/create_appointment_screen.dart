import 'package:doctors_app/models/appointment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctors_app/screens/patient/home/home_screen.dart';

class CreateAppointmentScreen extends StatefulWidget {
  String categoryId;
  String categoryTitle;
  String categoryImageUrl;
  String categoryAddress;
  String categorySpecialities;
  CreateAppointmentScreen(
      {@required this.categoryId,
      this.categoryTitle,
      this.categoryAddress,
      this.categoryImageUrl,
      this.categorySpecialities});
  @override
  _CreateAppointmentScreenState createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  DateTime selectedDate = DateTime.now();
//  CreateAppointmentModel appointment = CreateAppointmentModel();
  List<String> lst = ['Morning', 'Afternoon', 'Evening'];
  int selectedIndex = 0;

  final DatabaseReference database =
      FirebaseDatabase.instance.reference().child('appointments');

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        new Duration(days: 10),
      ),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            child: Text(
              'Select appointment time',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 0,
          ),
          Container(
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(
                width: .5,
                color: Colors.grey[400],
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 5, 5),
                  height: 58,
                  width: 58,
                  child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/doctor.png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.categoryTitle,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        widget.categorySpecialities,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(widget.categoryAddress),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(34, 20, 0, 0),
            child: Text(
              'Pick a Date',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  letterSpacing: 1.2),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(height: 10, thickness: 1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: selectedDate.isBefore(DateTime.now())
                          ? null
                          : () {
                              setState(() {
                                selectedDate =
                                    selectedDate.subtract(Duration(days: 1));
                              });
                            },
                      icon: Icon(Icons.arrow_back),
                    ),
                    FlatButton.icon(
                      onPressed: presentDatePicker,
                      icon: Icon(Icons.date_range),
                      label: Text(
                        DateFormat('E, dd MMMM').format(selectedDate),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    IconButton(
                      onPressed: selectedDate.isAfter(DateTime.now().add(
                        new Duration(days: 9),
                      ))
                          ? null
                          : () {
                              setState(() {
                                selectedDate =
                                    selectedDate.add(Duration(days: 1));
//                            appointment.date = selectedDate.toString();
                              });
                            },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(34, 5, 0, 0),
                child: Text(
                  'Pick a time slot',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      letterSpacing: 1.2),
                ),
              ),
              const SizedBox(
                height: 6.5,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // RaisedButton(
                    //   onPressed: _pushOn,
                    //   child: Text('Book',style: TextStyle(color: Colors.white,letterSpacing: 3.5,fontWeight: FontWeight.w800),),
                    //   color: Colors.teal[400],
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(5),
                    //   ),
                    // ),
                    customRadio(lst[0], 0),
                    customRadio(lst[1], 1),
                    customRadio(lst[2], 2),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 140,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 30, 5),
                child: Container(
                  height: 75,
                  width: 65,
                  child: FloatingActionButton(
                    onPressed: () {
                      _pushOn();
                    },
                    child: Icon(
                      Icons.check,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
      print(selectedIndex);
    });
  }

  Widget customRadio(String txt, int index) {
    return RaisedButton(
      onPressed: () {
        changeIndex(index);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
//      borderSide: BorderSide(color: selectedIndex == index ? Colors.teal : Colors.grey),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          txt,
          style: TextStyle(
              color: selectedIndex == index ? Colors.teal : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
      ),
    );
  }

  Future<void> _pushOn() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      Appointment appointment = Appointment(
          patientId: user.email, doctorId: widget.categoryId,
          time: selectedIndex.toString(), date: selectedDate.toString(), flag:'pending',
          dHelper: widget.categoryId+'_'+selectedDate.toString().split(' ')[0]+'_'+selectedIndex.toString(),
          pHelper: user.email+'_'+selectedDate.toString().split(' ')[0]+'_'+selectedIndex.toString()
      );

      await database.push().set({
        'patientId': appointment.patientId,
        'doctorId': appointment.doctorId,
        'date': appointment.date,
        'time': appointment.time,
        'flag': appointment.flag,
        'dHelper': appointment.dHelper,
        'pHelper': appointment.pHelper
      });
      Fluttertoast.showToast(
          msg: 'Appointment successful',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 14.0);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
          (Route<dynamic> route) => false);
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(
          msg: 'Appointment Error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
}

class AppointmentModel {
  String patientId;
  String doctorId;
  String date;
  String time;

  AppointmentModel(this.patientId, this.doctorId, this.time, this.date);
}
