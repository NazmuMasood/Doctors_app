import 'package:doctors_app/models/appointment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DocAppointmentListWidget extends StatelessWidget {
  final Appointment appointment;
  final Function onDonePressed, onUndonePressed;
  final int serial;
  final DatabaseReference patientsRef = FirebaseDatabase.instance.reference().child("users").child('patients');

  DocAppointmentListWidget({this.appointment, this.onDonePressed, this.onUndonePressed, this.serial});

  @override
  Widget build(BuildContext context) {
    return appointmentHistoryCard(context);
  }

  Widget appointmentHistoryCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15,14,8),
      child: Card(
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
                    backgroundImage: AssetImage('assets/images/patient.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    pNameFB(),
                    Text(
                      'ParkView Hospital',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      appointment.timeSlot == '0'
                          ? 'Slot: Morning'
                          : appointment.timeSlot == '1'
                          ? 'Slot: Afternoon'
                          : appointment.timeSlot == '2'
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
                        Text(
                          serial.toString() ?? '00',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                    Text(appointment.date.substring(8, 10),
                        style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(
                      appointment.date.substring(5, 7)=='01' ? 'JAN' :
                      appointment.date.substring(5, 7)=='02' ? 'FEB' :
                      appointment.date.substring(5, 7)=='03' ? 'MAR' :
                      appointment.date.substring(5, 7)=='04' ? 'APR' :
                      appointment.date.substring(5, 7)=='05' ? 'MAY' :
                      appointment.date.substring(5, 7)=='06' ? 'JUN' :
                      appointment.date.substring(5, 7)=='07' ? 'JUL' :
                      appointment.date.substring(5, 7)=='08' ? 'AUG' :
                      appointment.date.substring(5, 7)=='09' ? 'SEP' :
                      appointment.date.substring(5, 7)=='10' ? 'OCT' :
                      appointment.date.substring(5, 7)=='11' ? 'NOV' :
                      appointment.date.substring(5, 7)=='12' ? 'DEC' :
                      'Unknown',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 11, top: 17),
              child: Container(
                width: MediaQuery.of(context).size.width*0.85,
                height: 35,
                child: RaisedButton(
                  onPressed: appointment.flag=='pending'?onDonePressed : onUndonePressed,
                  child: Text(
                    appointment.flag=='pending' ? 'PENDING' : 'FINISHED',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 3.5,
                        fontWeight: FontWeight.w800),
                  ),
                  color: appointment.flag=='pending' ? Colors.blue : Colors.white12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pNameFB(){
    return FutureBuilder(
        future: patientsRef.orderByChild("email").equalTo(appointment.pId).once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> values = snapshot.data.value;
            if (values == null) {
              return Text(appointment.pId,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,),
              );
            }
            String pName;
            values.forEach((key, value) {
              pName = value['name'];
            });

            return Text(pName ?? appointment.pId,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,),
            );
          }

          return SizedBox(child: CircularProgressIndicator(),
            height: MediaQuery.of(context).size.width*.035,
            width: MediaQuery.of(context).size.width*.035,);
        });
  }
}


/*class AppointmentHistory extends StatefulWidget {
  @override
  _AppointmentHistoryState createState() => _AppointmentHistoryState();
}
class _AppointmentHistoryState extends State<AppointmentHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appointmentHistoryCard(),
    );
  }
  Widget appointmentHistoryCard()
  {
    return Column(
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
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 165,
            child: Card(
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
                          backgroundImage:
                          AssetImage('assets/images/doctor.png'),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Dr.Obayed Hasan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'ParkView Hospital',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Slot: Evening',
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
                              Text(
                                '01',
                                style: TextStyle(
                                  fontSize: 14,fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('30',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          Text(
                            'Aug',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 11,top: 17),
                    child: Container(width: 332,
                      height: 35,
                      child: RaisedButton(
                        onPressed: () => print('Appointment Cancelled'),
                        child: Text('Cancel Appointment',style: TextStyle(color: Colors.white,letterSpacing: 3.5,fontWeight: FontWeight.w800),),
                        color: Colors.teal[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}*/