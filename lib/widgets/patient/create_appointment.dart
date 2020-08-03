

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'appointment_slot_radio_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAppointmentWidget extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  final String categoryImageUrl;
  final String categoryAddress;
  final String categorySpecialities;
  CreateAppointmentWidget({this.categoryId,this.categoryTitle,this.categoryAddress,this.categoryImageUrl,this.categorySpecialities});

  @override
  _CreateAppointmentWidgetState createState() => _CreateAppointmentWidgetState();
}

class _CreateAppointmentWidgetState extends State<CreateAppointmentWidget> {
  DateTime selectedDate = DateTime.now();

  void presentDatePicker(){
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(new Duration(days: 10),
    ),
    ).then((value) {
      if(value == null)
      {
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
            padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 20),
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
                  margin: EdgeInsets.fromLTRB(20,5,5,5),
                  height: 58,
                  width: 58,
                  child: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('Image\n here'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Title Lorem Ipsum',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Specialities Lorem ipsum dolor sit',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text('Address Lorem ipsum dolor sit'),
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed:
                      selectedDate.isBefore(DateTime.now()) ? null: (){
                        setState(() {
                          selectedDate = selectedDate.subtract(Duration(days: 1));
                        });
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    FlatButton.icon(onPressed: presentDatePicker, icon: Icon(Icons.date_range), label:Text(DateFormat('E,ddMMMM').format(selectedDate),style: TextStyle(fontWeight:FontWeight.bold,fontSize: 17),),),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          selectedDate = selectedDate.add(Duration(days: 1));
                        });
                      },
                      icon:Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(34, 8, 0, 0),
                child: Text('Pick a time slot',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17),),
              ),
              AppointmentRadioButton(),
            ],
          ),
          SizedBox(
            height: 180,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 25,5),
                child: Container(
                  height: 75,
                  width: 65,
                  child: FloatingActionButton(
                    onPressed: (){
                      Fluttertoast.showToast(
                          msg: 'Appointment Successful',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.teal,
                          textColor: Colors.white,
                          fontSize: 14.0
                      );
                    },
                    child: Icon(Icons.check,size: 32,),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}