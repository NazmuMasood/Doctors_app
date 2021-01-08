import 'package:doctors_app/models/appointment.dart';
import 'package:doctors_app/services/helper_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'appointment_list_widget.dart';

class UpcomingApptListScreen extends StatefulWidget {
  final User user;

  UpcomingApptListScreen({this.user});

  @override
  _UpcomingApptListScreenState createState() => _UpcomingApptListScreenState();
}

class _UpcomingApptListScreenState extends State<UpcomingApptListScreen> {
  List<Appointment> appointments = [];
  DatabaseReference appointmentsRef =
      FirebaseDatabase.instance.reference().child("appointments");

  List appts = [];
  bool checkForUpdt = false;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: appointments.length == 0
            ? Text('No upcoming appointments')
            : getAppointmentsUi(appointments));
  }

  Widget getAppointmentsUi(List<Appointment> appointments) {
    return ListView.builder(
        padding: EdgeInsets.all(0),
        // physics: AlwaysScrollableScrollPhysics(),
        itemCount: appointments.length,
        itemBuilder: (context, index) => AppointmentListWidget(
              appointment: appointments[index],
              onCancelPressed: () {
                print('Appointment Cancel pressed on index $index');
                deleteAppointment(index);
              },
            ));
  }

  Future<void> deleteAppointment(int index) async {
    String apptId = appointments[index].apptId;
    await appointmentsRef.child(apptId).remove().then((_) {
      print("Delete appointment $apptId successful");
    });
  }

  @override
  void initState() {
    super.initState();
    appts = FirebaseList(
        query: appointmentsRef
            .orderByChild("pHelper")
            .equalTo(widget.user.email + '_pending'),
        onChildAdded: (pos, snapshot) {
          if (!checkForUpdt) {
            return;
          }
          Map<dynamic, dynamic> values = snapshot.value;
          if (values != null) {
            print('onAdded appointment: ' + values.toString());
          }
        },
        onChildRemoved: (pos, snapshot) {
          Map<dynamic, dynamic> values = snapshot.value;
          if (values != null) {
            print('onRemoved appointment: ' + values.toString());
          }
        },
        onValue: (snapshot) {
          appointments = [];
          for (var i = 0; i < this.appts.length; i++) {
            print('!!!~~~ $i: ${appts[i].value['dHelper']}');
            Appointment appointment = Appointment.fromMap(appts[i].value);
            appointments.add(appointment);
          }
          checkForUpdt = true;
          setState(() {});
        },
        onChildChanged: (pos, snapshot) {},
        onError: (error) {
          print('FirebaseList error upcomingAppts : ${error.message}');
          HelperClass.showToast('Error in fetching upcoming appointment');
        });
  }
}
