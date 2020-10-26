import 'package:doctors_app/models/appointment.dart';
import 'package:doctors_app/models/patient.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseReference patientsRef =
      FirebaseDatabase.instance.reference().child("users").child("patients");

  final ageCont = TextEditingController();
  final weigtCont = TextEditingController();
  final bloodgroupCont = TextEditingController();

  Patient patient;
  List<dynamic> keys = [];
  Patient updatePatient;
  bool isLoading = false;
  String pKey = '';

  DateTime selectedDate = DateTime.now();
//  CreateAppointmentModel appointment = CreateAppointmentModel();
  List<String> lst = ['Morning', 'Afternoon', 'Evening'];
  int selectedIndex = 0;

  final DatabaseReference appointmentsRef =
      FirebaseDatabase.instance.reference().child('appointments');

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        new Duration(days: 30),
      ),
      lastDate: DateTime.now().add(
        new Duration(days: 30),
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
          Flexible(
            child: FractionallySizedBox(
              heightFactor: 0.9,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 35, 0),
                child: Container(
                  height: 85,
                  width: 75,
                  child: FloatingActionButton(
                    onPressed: () {
                      checkIfProfileUpdated();
                    },
                    child: Icon(
                      Icons.check,
                      size: 42,
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

  Future<void> checkIfProfileUpdated() async {
    User user = FirebaseAuth.instance.currentUser;

    DatabaseReference patientsRef =
        FirebaseDatabase.instance.reference().child("users").child('patients');
    patientsRef
        .orderByChild('email')
        .equalTo(user.email)
        .once()
        .then((DataSnapshot snap) {
      Map values = snap.value;
      print('profile view: values- '+values.toString());
      values.forEach((key, value) {
        if (value['age'] != null &&
            value['weight'] != null &&
            value['bloodgroup'] != null) {
          _pushOn();
        }
        else{
          showModelBottomSheet(value: value, pKey: key);
        }
      });
    });
  }

  void showModelBottomSheet({var value, String pKey}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (value['age'] == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Age'),
                        controller: ageCont,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please Input Age';
                          }
                          return null;
                        },
                          onSaved: (input) => ageCont.text = input.trim(),
                      ),
                    ),
                  if (value['weight'] == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Weight'),
                        controller: weigtCont,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please Input Weight';
                          }
                          return null;
                        },
                        onSaved: (input) => weigtCont.text = input.trim(),
                      ),
                    ),
                  if (value['bloodgroup'] == null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'BloodGroup'),
                        controller: bloodgroupCont,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please Input BloodGroup';
                          }
                          return null;
                        },
                        onSaved: (input) => bloodgroupCont.text = input.trim(),
                      ),
                    ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FlatButton(
                      height: 30,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        onPressed: () => updateProfile(value: value, pKey: pKey),
                        color: Colors.teal,
                        child: Container(
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          ),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> updateProfile({var value, String pKey}) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        if (value['age'] == null) {
          await patientsRef.child(pKey).child('age').set(ageCont.text);
        }
        if (value['weight'] == null) {
          await patientsRef.child(pKey).child('weight').set(weigtCont.text);
        }
        if (value['bloodgroup'] == null) {
          await patientsRef
              .child(pKey)
              .child('bloodgroup')
              .set(bloodgroupCont.text);
        }
        Fluttertoast.showToast(
            msg: 'Profile Updated',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
        Navigator.of(context).pop();
      }
      catch (e) {
        print(e.message);
        Fluttertoast.showToast(
            msg: 'Update Unsuccessful',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
  }

  Future<void> _pushOn() async {
    try {
      User user = FirebaseAuth.instance.currentUser;

      String apptId = appointmentsRef.push().key;

      Appointment appointment = Appointment(
          pId: user.email,
          dId: widget.categoryId,
          timeSlot: selectedIndex.toString(),
          date: selectedDate.toString().split(' ')[0],
          createdAt: DateTime.now().millisecondsSinceEpoch,
          flag: 'pending',
          dHelper: widget.categoryId +
              '_' +
              selectedDate.toString().split(' ')[0] +
              '_' +
              selectedIndex.toString(),
          pHelper: user.email +
              '_' +
              'pending',
          dHelperFull: widget.categoryId +
              '_' +
              selectedDate.toString().split(' ')[0] +
              '_' +
              selectedIndex.toString() +
              '_' +
              'pending',
          apptId: apptId
      );

      await appointmentsRef.child(apptId).set(appointment.toMap());
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

/*class AppointmentModel {
  String patientId;
  String doctorId;
  String date;
  String time;

  AppointmentModel(this.patientId, this.doctorId, this.time, this.date);
}*/
