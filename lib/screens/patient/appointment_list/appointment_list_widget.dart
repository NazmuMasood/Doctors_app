
import 'dart:collection';

import 'package:doctors_app/models/appointment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentListWidget extends StatefulWidget {
  final Appointment appointment;
  final Function onCancelPressed;

  AppointmentListWidget({this.appointment, this.onCancelPressed});

  @override
  _AppointmentListWidgetState createState() => _AppointmentListWidgetState();
}

class _AppointmentListWidgetState extends State<AppointmentListWidget> {
  DatabaseReference appointmentsRef;
  DatabaseReference doctorsRef;
  int serial = 0;

  @override
  Widget build(BuildContext context) {
    return appointmentHistoryCard(context);
  }

  Widget appointmentHistoryCard(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 15,14,8),
      child: Card(
        elevation: 2.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 37,
                    backgroundImage: AssetImage('assets/images/doctor.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    docNameFB(),
                    Text(
                      'ParkView Hospital',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.appointment.timeSlot == '0'
                          ? 'Slot: Morning'
                          : widget.appointment.timeSlot == '1'
                              ? 'Slot: Afternoon'
                              : widget.appointment.timeSlot == '2'
                                  ? 'Slot: Evening'
                                  : 'Slot: Unknown',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Serial: ',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        serialFB(),
                      ],
                    ),
                  ],
                ),
                Flexible(
                  child: FractionallySizedBox(
                    widthFactor: 0.80,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.appointment.date.substring(8, 10),
                        style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(
                      widget.appointment.date.substring(5, 7)=='01' ? 'JAN' :
                      widget.appointment.date.substring(5, 7)=='02' ? 'FEB' :
                      widget.appointment.date.substring(5, 7)=='03' ? 'MAR' :
                      widget.appointment.date.substring(5, 7)=='04' ? 'APR' :
                      widget.appointment.date.substring(5, 7)=='05' ? 'MAY' :
                      widget.appointment.date.substring(5, 7)=='06' ? 'JUN' :
                      widget.appointment.date.substring(5, 7)=='07' ? 'JUL' :
                      widget.appointment.date.substring(5, 7)=='08' ? 'AUG' :
                      widget.appointment.date.substring(5, 7)=='09' ? 'SEP' :
                      widget.appointment.date.substring(5, 7)=='10' ? 'OCT' :
                      widget.appointment.date.substring(5, 7)=='11' ? 'NOV' :
                      widget.appointment.date.substring(5, 7)=='12' ? 'DEC' :
                      'Unknown',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            widget.appointment.flag=='pending'? Padding(
              padding: const EdgeInsets.only(bottom: 15, top: 17),
              child: Container(
                width: MediaQuery.of(context).size.width*.80,
                height: 35,
                child: RaisedButton(
                  onPressed: widget.appointment.flag=='pending'? widget.onCancelPressed : (){},
                  child: Text(
                    widget.appointment.flag=='pending'?'Cancel Appointment' : 'FINISHED',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 3.5,
                        fontWeight: FontWeight.w800),
                  ),
                  color: widget.appointment.flag=='pending'?Colors.teal[400] : Colors.white12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ) : SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  Widget serialFB(){
    return FutureBuilder(
        future: appointmentsRef.orderByChild("dHelper").equalTo(widget.appointment.dHelper).once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> values = snapshot.data.value;
            if (values == null) {
              return Text('error',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
              );
            }

            if(values.length>1){values = sortListMap(values);}

            int count = 1;
            values.forEach((key, value) {
              if(value['pId'] == widget.appointment.pId && value['createdAt'] == widget.appointment.createdAt){
                serial = count;
              }
              count++;
            });

            return Text(serial.toString() ?? 'error',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
            );
          }

          return SizedBox(child: CircularProgressIndicator(),
            height: MediaQuery.of(context).size.width*.025,
            width: MediaQuery.of(context).size.width*.025,);
        });
  }

  Widget docNameFB(){
    return FutureBuilder(
        future: doctorsRef.orderByChild("email").equalTo(widget.appointment.dId).once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> values = snapshot.data.value;
            if (values == null) {
              return Text(widget.appointment.dId,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,),
              );
            }
            String docName;
            values.forEach((key, value) {
              docName = value['name'];
            });

            return Text(docName ?? widget.appointment.dId,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,),
            );
          }

          return SizedBox(child: CircularProgressIndicator(),
            height: MediaQuery.of(context).size.width*.035,
            width: MediaQuery.of(context).size.width*.035,);
        });
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
    return resMap;
  }

  @override
  void initState() {
    super.initState();
    appointmentsRef = FirebaseDatabase.instance.reference().child("appointments");
    doctorsRef = FirebaseDatabase.instance.reference().child("users").child('doctors');
  }
}