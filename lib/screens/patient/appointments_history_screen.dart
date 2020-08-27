import 'package:doctors_app/widgets/patient/appointment_history_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/models/appointment.dart';
import 'dart:convert';

class AppointmentHistoryScreen extends StatefulWidget {
  const AppointmentHistoryScreen({Key key, @required this.user})
      : super(key: key);
  final FirebaseUser user;

  @override
  _AppointmentHistoryScreenState createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  List<Appointment> appointments = [];
  List<dynamic> keys = [];
  DatabaseReference appointmentsRef =
      FirebaseDatabase.instance.reference().child("appointments");
  bool firstTimeLoading = true;

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
      child: firstTimeLoading ? FutureBuilder(
          future: appointmentsRef
              .orderByChild("patientId")
              .equalTo(widget.user.email)
              .once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData) {
              firstTimeLoading = false;
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
          }) : getAppointmentsUi(appointments),
    );
  }

  Widget getAppointmentsUi(List<Appointment> appointments) => ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) => AppointmentHistoryWidget(
            appointment: appointments[index],
            onCancelPressed: () {
              print('Appointment Cancelled with - '+keys[index].toString()+"on index $index");
              deleteAppointment(keys[index].toString(), index);
              //Navigator.pushNamed(context, 'post', arguments: appointments[index]);
            },
          ));

  Future<void> refresh() async {
    setState(() {
      firstTimeLoading = true;
      appointments = [];
      keys = [];
    });
  }

  Future<void> deleteAppointment(String appointmentId, int index) async{
    await appointmentsRef.child(appointmentId).remove().then((_) {
      print("Delete appointment $appointmentId successful");
      setState(() {
        appointments.removeAt(index);
        keys.removeAt(index);
      });
    });
  }
}
