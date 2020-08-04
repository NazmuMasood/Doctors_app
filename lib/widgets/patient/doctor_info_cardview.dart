import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:doctors_app/widgets/patient/create_appointment.dart';
import 'file:///C:/Users/Maroof/AndroidStudioProjects/Doctors_app/lib/models/doctors.dart';
import 'package:firebase_database/firebase_database.dart';

class DoctorInfoCardviewWidget extends StatefulWidget {
  @override
  _DoctorInfoCardviewWidgetState createState() =>
      _DoctorInfoCardviewWidgetState();
}

class _DoctorInfoCardviewWidgetState extends State<DoctorInfoCardviewWidget> {
  final _searchedDocController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 60,
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
                          onSubmitted: (str) {},
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onPressed: () => print(_searchedDocController.text.trim()),
                  ///TODO: Controller.text
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(padding: EdgeInsets.all(2),shrinkWrap: true,itemCount: doclist.length,itemBuilder: (_, index)
          {
           return DocListUI(doclist[index].address,doclist[index].category,doclist[index].degrees,doclist[index].email,doclist[index].name,doclist[index].specialities);
          },
          ),
        ),
      ],
    );
  }



  Widget DocListUI(String address, String category, String degrees, String email,
      String name, String specialities) {
    return Container(
      padding: EdgeInsets.fromLTRB(21, 0, 21, 0),
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
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                              image: AssetImage('assets/images/doctor.png'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                degrees,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                address,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
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
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 10, 4),
                                width: 150,
                                height: 35,
                                child: RaisedButton(
                                  onPressed: () => null,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(
                                          color:
                                          Color.fromRGBO(28, 222, 187, 1))),
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
                                padding: EdgeInsets.fromLTRB(3, 0, 0, 5),
                                child: RaisedButton(
                                  onPressed: () {print(email);
                                             bookAppointment(context,email,address,specialities,name);

                                             },
                                  color: Colors.teal[400],
                                  //Color.fromRGBO(28, 222, 187, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
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
  }

  void bookAppointment(BuildContext ctx, id,address,specialities,name) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) {
        return CreateAppointmentWidget(categoryId: id,categoryAddress:address,categorySpecialities: specialities,categoryTitle: name);
      }
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _searchedDocController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    DatabaseReference postsRef =
    FirebaseDatabase.instance.reference().child('users').child('doctors');

    postsRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      doclist.clear();

      for (var individualKey in KEYS) {
        Doctor doctors = new Doctor(
          DATA[individualKey]['address'],
          DATA[individualKey]['category'],
          DATA[individualKey]['degrees'],
          DATA[individualKey]['email'],
          DATA[individualKey]['name'],
          DATA[individualKey]['specialities'],
        );
        doclist.add(doctors);
      }
      setState(() {
        print('Length:${doclist.length}');
      });
    });
  }

  List<Doctor> doclist = [];

}
