import 'package:doctors_app/screens/patient/appointment_list/appointment_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/models/appointment.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  List<Appointment> appointments = [];
  List<dynamic> keys = [];
  DatabaseReference appointmentsRef =
      FirebaseDatabase.instance.reference().child("appointments");
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Morning';
  String timeSlot = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26, bottom: 3),
            child: Text(
              'Appointments',
              style: TextStyle(fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                FlatButton.icon(
                  onPressed: presentDatePicker,
                  icon: Icon(Icons.date_range),
                  label: Text(
                    DateFormat('E, dd MMM').format(selectedDate),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
                FlatButton(
                  child: dropDownList(),
                  onPressed: null,
                )
              ],
            ),
          ),
          Expanded(child: allAppointmentsFutureBuilder()),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget allAppointmentsFutureBuilder() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: FutureBuilder(
          future: appointmentsRef
              .orderByChild("pHelper")
              .equalTo(widget.user.email+'_'+selectedDate.toString().split(' ')[0]+'_'+timeSlot)
              .once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            print('pHelper-> '+widget.user.email+'_'+selectedDate.toString().split(' ')[0]+'_'+timeSlot);
            if (snapshot.hasData) {
              appointments.clear();
              keys.clear();
              Map<dynamic, dynamic> values = snapshot.data.value;
              print('Downloaded snapshot -> ' + snapshot.data.value.toString());
              if (values == null) {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(child: Text('No results found')),
                    height: MediaQuery.of(context).size.height - 165,
                  ),
                );
              }
              values.forEach((key, values) {
                keys.add(key);
                appointments.add(Appointment.fromMap(values));
              });
              print('Appointments list length -> ' +
                  appointments.length.toString());
              /*var appointmentsJson = json.decode(snapshot.data.value);
                if (appointmentsJson == null) {
                  return Center(child: Text("No results found"));
                }
                for(var appointmentJson in appointmentsJson){
                  appointments.add(Appointment.fromJson(appointmentJson));
                }*/
              return getAppointmentsUi(appointments);
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget getAppointmentsUi(List<Appointment> appointments) => ListView.builder(
      padding: EdgeInsets.all(0),
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) => AppointmentListWidget(
            appointment: appointments[index],
            onCancelPressed: () {
              print('Appointment Cancelled with - ' +
                  keys[index].toString() +
                  "on index $index");
              deleteAppointment(keys[index].toString(), index);
              //Navigator.pushNamed(context, 'post', arguments: appointments[index]);
            },
          ));


  Widget dropDownList(){
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 20,
      elevation: 16,
      style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700,fontSize: 15,fontFamily: 'Avenir'),
      underline: Container(
        height: 2,
        color: Colors.teal,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          timeSlot = newValue=='Morning'?'0' : newValue=='Afternoon'?'1' : newValue=='Evening'?'2': '00';
        });
      },
      items: <String>['Morning', 'Afternoon', 'Evening']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }


  Future<void> refresh() async {
    setState(() {
      appointments = [];
      keys = [];
    });
  }

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

  Future<void> deleteAppointment(String appointmentId, int index) async {
    await appointmentsRef.child(appointmentId).remove().then((_) {
      print("Delete appointment $appointmentId successful");
      setState(() {
        appointments.removeAt(index);
        keys.removeAt(index);
      });
    });
  }
}
