import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:doctors_app/dummy/dummy_doctors.dart';
import 'package:doctors_app/widgets/patient/create_appointment.dart';

class DoctorInfoCardviewWidget extends StatefulWidget {
  @override
  _DoctorInfoCardviewWidgetState createState() => _DoctorInfoCardviewWidgetState();
}

class _DoctorInfoCardviewWidgetState extends State<DoctorInfoCardviewWidget> {
  final _searchedDocController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 302,
                  height: 50,
                  //padding: EdgeInsets.all(7),
                  margin: EdgeInsets.fromLTRB(23, 7, 3, 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 2,
                    color: Colors.grey[200],
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 5, 0),
//                          child: Icon(
//                            Icons.search,
//                            color: Colors.grey[700],
//                            size: 25,
//                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchedDocController,
                            /*    onSubmitted: (str) {

                            },*/
                            decoration: InputDecoration(
                                hintText: 'Search for Doctors',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 43,
                  width: 55,
                  child: RaisedButton(
                    color: Colors.teal[300],
                    elevation: 2,
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onPressed: ()=>print(_searchedDocController.text.trim()), ///TODO: Controller.text
                    child: Icon(Icons.search,color: Colors.white,size: 27,),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: dummy_doctors.map((tx) {
              return Container(
                padding: EdgeInsets.fromLTRB(21, 5, 21, 6),
                height: 165,
                child: Column(
                  children: <Widget>[
                    Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Container(
                          height: 146,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    height: 60,
                                    width: 60,
                                    child: CircleAvatar(
                                      child: Image(
                                        image: NetworkImage(tx.imageUrl),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(8, 14, 8, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          tx.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          tx.degrees,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          tx.address,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                          EdgeInsets.fromLTRB(5, 0, 10, 4),
                                          width: 150,
                                          height: 35,
                                          child: RaisedButton(
                                            onPressed: () => null,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(6),
                                                side: BorderSide(
                                                    color: Color.fromRGBO(
                                                        28, 222, 187, 1))),
                                            child: Text(
                                              'View Profile',
                                              style: TextStyle(
                                                color: Colors.teal[600],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 35,
                                          width: 185,
                                          padding:
                                          EdgeInsets.fromLTRB(3, 0, 0, 5),
                                          child: RaisedButton(
                                            onPressed: () => bookAppointment(context),
                                            color: Colors.teal[400],
                                            //Color.fromRGBO(28, 222, 187, 1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'Book Appointment',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void bookAppointment(BuildContext ctx){
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return CreateAppointmentWidget();
    },));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _searchedDocController.dispose();
    super.dispose();
  }
}