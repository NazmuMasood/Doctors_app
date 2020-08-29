import 'package:doctors_app/screens/doctor/appointment_list/doc_appointment_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/models/appointment.dart';
import 'dart:convert';

class DocAppointmentListScreen extends StatefulWidget {
  const DocAppointmentListScreen({Key key, @required this.user})
      : super(key: key);
  final FirebaseUser user;

  @override
  _DocAppointmentListScreenState createState() =>
      _DocAppointmentListScreenState();
}

class _DocAppointmentListScreenState extends State<DocAppointmentListScreen> {
  List<Appointment> appointments = [];
  List<dynamic> keys = [];
  DatabaseReference appointmentsRef =
      FirebaseDatabase.instance.reference().child("appointments");

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
              .orderByChild("doctorId")
              .equalTo(widget.user.email)
              .once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
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
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) => DocAppointmentListWidget(
            appointment: appointments[index],
            onDonePressed: () {
              print('Appointment Done with - ' +
                  keys[index].toString() +
                  "on index $index");
              doneAppointment(keys[index].toString(), index);
              //Navigator.pushNamed(context, 'post', arguments: appointments[index]);
            },
            onUndonePressed: () {
              print('Appointment Undone with - ' +
                  keys[index].toString() +
                  "on index $index");
              undoneAppointment(keys[index].toString(), index);
              //Navigator.pushNamed(context, 'post', arguments: appointments[index]);
            },
          ));

  Future<void> refresh() async {
    setState(() {
      appointments = [];
      keys = [];
    });
  }

  Future<void> doneAppointment(String appointmentId, int index) async {
    await appointmentsRef
        .child(appointmentId)
        .child('flag')
        .set('done')
        .then((_) {
      print("Done appointment $appointmentId successful");
      setState(() {});
    });
  }

  Future<void> undoneAppointment(String appointmentId, int index) async {
    await appointmentsRef
        .child(appointmentId)
        .child('flag')
        .set('pending')
        .then((_) {
      print("Undone appointment $appointmentId successful");
      setState(() {});
    });
  }
}
