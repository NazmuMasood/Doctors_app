import 'package:doctors_app/models/appointment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DocAppointmentListWidget extends StatelessWidget {
  final Appointment appointment;
  final Function onDonePressed, onUndonePressed;

  DocAppointmentListWidget({this.appointment, this.onDonePressed, this.onUndonePressed});

  @override
  Widget build(BuildContext context) {
    return appointmentHistoryCard();
  }

  Widget appointmentHistoryCard() {
    return Card(
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
                  backgroundImage: AssetImage('assets/images/patient_custom.png'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    appointment.patientId,
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
                    appointment.time == '0'
                        ? 'Slot: Morning'
                        : appointment.time == '1'
                            ? 'Slot: Afternoon'
                            : appointment.time == '2'
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
                        '01',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointment.date.substring(8, 10),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text(
                    appointment.date.substring(5, 7)=='08' ? 'AUG' :
                    appointment.date.substring(5, 7)=='09' ? 'SEP' :
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
              width: 332,
              height: 35,
              child: RaisedButton(
                onPressed: appointment.flag=='pending'?onDonePressed : onUndonePressed,
                child: Text(
                  appointment.flag=='pending' ? 'FINISH' : 'FINISHED',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.w800),
                ),
                color: appointment.flag=='pending' ? Colors.deepOrangeAccent : Colors.white12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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