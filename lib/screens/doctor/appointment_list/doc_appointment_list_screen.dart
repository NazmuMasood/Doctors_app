import 'package:doctors_app/models/message.dart';
import 'package:doctors_app/screens/doctor/appointment_list/doc_appointment_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/models/appointment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class DocAppointmentListScreen extends StatefulWidget {
  const DocAppointmentListScreen({Key key, @required this.user})
      : super(key: key);
  final User user;

  @override
  _DocAppointmentListScreenState createState() =>
      _DocAppointmentListScreenState();
}

class _DocAppointmentListScreenState extends State<DocAppointmentListScreen> {
  List<Appointment> appointments = [];
  List<dynamic> keys = [];
  DatabaseReference appointmentsRef =
      FirebaseDatabase.instance.reference().child("appointments");
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Morning';
  String timeSlot = '0';
  var msgController = TextEditingController();
  bool pressAll = false;

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
            child: Row(
              children: [
                Text(
                  'Appointments',
                  style: TextStyle(fontSize: 25),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 120.0),
                  child: new RaisedButton(
                    child: new Text('All'),
                    textColor: pressAll ? Colors.white : Colors.black,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    color: pressAll ? Colors.grey : Colors.white30,
                    onPressed: () => setState(() => pressAll = !pressAll),
                  ),
                ),
              ],
            ),
          ),
          !pressAll
              ? Padding(
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
                )
              : Container(),
          !pressAll
              ? Padding(
                  padding: const EdgeInsets.only(left: 23),
                  child: Stack(
                    children: [
                      Container(
                        width: 365,
                        height: 65,
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Message'),
                          controller: msgController,
                        ),
                      ),
                      Positioned(
                        left: 300,
                        top: 9,
                        child: FlatButton(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () => sendMessage(),
                          color: Colors.blue,
                          shape: CircleBorder(),
                          //height: 40,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Expanded(child: appointmentsFutureBuilder()),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget appointmentsFutureBuilder() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: checkIfAll(),
    );
  }

  Widget checkIfAll() {
    if (pressAll) {
      return allAppointments();
    }
    return sortedAppointments();
  }

  Widget allAppointments() {
    return FutureBuilder(
        future: appointmentsRef
            .orderByChild("doctorId")
            .equalTo(widget.user.email)
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          print('doctorId-> ' + widget.user.email);
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
            return getAppointmentsUi(appointments);
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget sortedAppointments() {
    return FutureBuilder(
        future: appointmentsRef
            .orderByChild("dHelper")
            .equalTo(widget.user.email +
                '_' +
                selectedDate.toString().split(' ')[0] +
                '_' +
                timeSlot)
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          print('dHelper-> ' +
              widget.user.email +
              '_' +
              selectedDate.toString().split(' ')[0] +
              '_' +
              timeSlot);
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
        });
  }

  Widget getAppointmentsUi(List<Appointment> appointments) => ListView.builder(
      padding: EdgeInsets.all(0),
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

  Widget dropDownList() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 20,
      elevation: 16,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          fontFamily: 'Avenir'),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          timeSlot = newValue == 'Morning'
              ? '0'
              : newValue == 'Afternoon'
                  ? '1'
                  : newValue == 'Evening' ? '2' : '00';
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

  Future<void> sendMessage() async {
    FocusScope.of(context).unfocus();
    if(msgController.text.isEmpty){return;}
    print('Message : ' + msgController.text);
    Message msg = new Message(
        dId: widget.user.email,
        dHelper: widget.user.email +'_' + selectedDate.toString().split(' ')[0] + '_' + timeSlot,
        date: DateTime.now().toString(),
        msg: msgController.text);

    try {
      DatabaseReference msgRef = FirebaseDatabase.instance.reference().child("messages");
      await msgRef.push().set(msg.toMap());

      msgController.clear();
      Fluttertoast.showToast(
          msg: 'Message sending success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 14.0);
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(
          msg: 'Message sending error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 14.0);
    }
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

  Future<void> refresh() async {
    setState(() {
      appointments = [];
      keys = [];
      msgController.clear();
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
