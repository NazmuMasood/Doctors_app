import 'dart:collection';
import 'package:doctors_app/models/message.dart';
import 'package:doctors_app/models/running_slot.dart';
import 'package:doctors_app/screens/doctor/appointment_list/doc_appointment_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
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
  DatabaseReference appointmentsRef;
  DatabaseReference runningSlotsRef;
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Morning';
  String timeSlot = '0';
  String dHelper = '';
  var msgController = TextEditingController();
  bool pressAll = false;
  bool slotStateLoading = false;
  String slotState = 'notStarted';
  String slotKey = '';
  var apptSubscription;

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
                SizedBox(width: slotStateLoading? 80: 110,),
                slotStateLoading? CircularProgressIndicator(): Container(),
                Container(
                  margin: const EdgeInsets.only(left: 10.0),
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
                    mainAxisSize: MainAxisSize.max,
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
                      ),
                      SizedBox(
                        width: slotState=='notStarted' || slotState == 'ended'? 60 : slotState == 'paused' || slotState=='running'? 10
                            : 0,
                      ),
                      slotState=='notStarted' || slotState=='paused' || slotState == 'ended' ? Expanded(
                        child: Container(
                          child:  FlatButton(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: () => setSlotState('running'),
                            color: Colors.blue,
                            shape: CircleBorder(),
                            //height: 40,
                          ),
                        ),
                        flex: 2,
                      ): Container(),
                      slotState=='running' ? Expanded(
                        child: Container(
                          child:  FlatButton(
                            child: Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () => setSlotState('paused'),
                            color: Colors.blue,
                            shape: CircleBorder(),
                            //height: 40,
                          ),
                        ),
                        flex: 2,
                      ): Container(),
                      slotState=='running' || slotState=='paused' ? Expanded(
                        child: Container(
                          child:  FlatButton(
                            child: Icon(
                              Icons.stop,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () => setSlotState('ended'),
                            color: Colors.blue,
                            shape: CircleBorder(),
                            //height: 40,
                          ),
                        ),
                        flex: 2,
                      ): Container(),
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
            .orderByChild("dId")
            .equalTo(widget.user.email)
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          print('doctorId-> ' + widget.user.email);
          if (snapshot.hasData) {
            appointments.clear();
            keys.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            //print('Downloaded snapshot -> ' + snapshot.data.value.toString());
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
            .equalTo(dHelper)
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          print('dHelper-> ' + dHelper);
          if (snapshot.hasData) {
            appointments.clear();
            keys.clear();

            Map<dynamic, dynamic> values = snapshot.data.value;
            //print('Downloaded snapshot -> ' + snapshot.data.value.toString());
            if (values == null) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  child: Center(child: Text('No results found')),
                  height: MediaQuery.of(context).size.height - 165,
                ),
              );
            }

            if(values.length>1){values = sortListMap(values);}

            values.forEach((key, values) {
              keys.add(key);
              appointments.add(Appointment.fromMap(values));
            });
            print('Appointments list length -> ' + appointments.length.toString());

            checkForNewAppt = true;
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
            serial: index+1,
            onDonePressed: () {
              print('Appointment Done with - '+keys[index].toString()+"on index $index");
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
          dHelper = widget.user.email + '_' + selectedDate.toString().split(' ')[0] + '_' + timeSlot;
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
    if(msgController.text.isEmpty || appointments.isEmpty){return;}
    print('Message : ' + msgController.text);
    Message msg = new Message(
        dId: widget.user.email,
        dHelperFull: widget.user.email +'_' + selectedDate.toString().split(' ')[0] + '_' + timeSlot+'_pending',
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

  Future<void> doneAppointment(String appointmentId, int index) async {
    if(slotState == 'notStarted' || slotState == 'paused'){showToast('Please start the appointment slot first'); return;}
    try {
      await appointmentsRef.child(appointmentId).child('flag').set('done').then((_) {
        print("Done appointment $appointmentId successful");
        setState(() {});
      });

      await appointmentsRef.child(appointmentId).child('dHelperFull').set(dHelper+'_done').then((_) {
        print("Update dHelperFull of appointment $appointmentId successful");
      });

      print('slotKey: $slotKey');
      await runningSlotsRef.child(slotKey).child('currentSerial').set((index+2).toString());
    }catch (e) {
      print(e.message);
      showToast('Couldn\'t update current serial');
    }
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

    await appointmentsRef.child(appointmentId).child('dHelperFull').set(dHelper+'_pending').then((_) {
      print("Update dHelperFull of appointment $appointmentId successful");
    });
  }

  Future<void> setSlotState(String mSlotState) async{
    if(slotStateLoading){return;}
    if(appointments.isEmpty){showToast('There\'s no patient in this slot'); return;}
    print('slotState : '+mSlotState);
    setState(() {slotStateLoading = true;});
    try {
      String appointmentDate = selectedDate.toString().split(' ')[0];
      String msgToSend = '';

      runningSlotsRef.orderByChild('dHelper').equalTo(dHelper).once().then((DataSnapshot snapshot) async {
        Map<dynamic, dynamic> values = snapshot.value;
        if(values == null){
          RunningSlot newRunningSlot = new RunningSlot(
              currentSerial: '1',
              dHelper: dHelper,
              slotState: 'running',
              dId: widget.user.email
          );
          await runningSlotsRef.push().set(newRunningSlot.toMap());
          msgToSend = 'Patient checking of $appointmentDate has been started';
          checkForCurrentSlotState();
        }
        else {
          String key = '';
          values.forEach((mKey, value) {key = mKey;});
          print('key: $key, snapshot: ${snapshot.value}');

          if (mSlotState == 'ended') {
            await runningSlotsRef.child(key).remove();
            msgToSend = 'Sorry, patient checking of $appointmentDate has ended for now';
          }
          else {
            await runningSlotsRef.child(key).child('slotState').set(mSlotState);
            msgToSend = 'Patient checking of $appointmentDate has been paused';
          }
        }

        Message msg = new Message(
            dId: widget.user.email,
            dHelperFull: dHelper+'_pending',
            date: DateTime.now().toString(),
            msg: msgToSend);
        DatabaseReference msgRef = FirebaseDatabase.instance.reference().child("messages");
        await msgRef.push().set(msg.toMap());

        setState(() {
          slotState = mSlotState;
          slotStateLoading = false;
        });
        Fluttertoast.showToast(
            msg: 'Slot state updated successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      });
    } catch (e) {
      print(e.message);
      setState(() {
        slotStateLoading = false;
      });
      Fluttertoast.showToast(
          msg: 'Slot state updating error',
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
      initialDate: selectedDate,
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
        dHelper = widget.user.email + '_' + value.toString().split(' ')[0] + '_' + timeSlot;
      });

      checkForCurrentSlotState();
    });
  }

  Future<void> refresh() async {
    setState(() {
      appointments = [];
      keys = [];
      msgController.clear();
      // slotState = 'notStarted';
    });

    checkForCurrentSlotState();
  }

  List appts = []; bool checkForNewAppt = false;
  @override
  void initState() {
    super.initState();
    dHelper = widget.user.email + '_' + selectedDate.toString().split(' ')[0] + '_' + timeSlot;
    appointmentsRef = FirebaseDatabase.instance.reference().child("appointments");
    runningSlotsRef = FirebaseDatabase.instance.reference().child("running-slots");
    checkForCurrentSlotState();
    appts = FirebaseList(
      query: appointmentsRef.orderByChild("dHelper").equalTo(dHelper),
      onChildAdded: (pos, snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        if(values != null && checkForNewAppt){
          print('New appointment: '+values.toString());
          refresh();
        }
      },
      ///TODO: remove the sortedAppointments futureBuilder
        ///instead use this onValue to load data
      onValue: (snapshot) {
        /*for (var i=0; i < this.appts.length; i++) {
          print('hmmm $i: ${appts[i].value}');
        }*/
      }
    );
  }

  Future<void> checkForCurrentSlotState() async{
    runningSlotsRef.orderByChild('dHelper').equalTo(dHelper).once().then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> values = snapshot.value;
      if(values == null){ setState(() { slotState = 'notStarted'; }); return;}
      values.forEach((key, value) {
        print('slotKey: $key, slotState: '+value['slotState']);
        setState(() {slotKey = key; slotState = value['slotState'];});
      });
    });
  }

  void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  LinkedHashMap sortListMap(LinkedHashMap map) {
    List mapKeys = map.keys.toList(growable : false);
    mapKeys.sort((k1, k2) {
      int timestamp1 = map[k1]['createdAt'];
      int timestamp2 = map[k2]['createdAt'];
      return timestamp1.compareTo(timestamp2);
    });
    LinkedHashMap resMap = new LinkedHashMap();
    mapKeys.forEach((k1) { resMap[k1] = map[k1] ; }) ;
    // print('before sorting: '+map.toString());
    // print('after sorting: '+resMap.toString());
    return resMap;
  }
}
