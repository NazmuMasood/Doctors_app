import 'file:///C:/Users/ASUS/AndroidStudioProjects/doctors_app/lib/models/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:doctors_app/widgets/patient/create_appointment.dart';
import 'package:doctors_app/models/doctors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:algolia/algolia.dart';

class DoctorInfoCardviewWidget extends StatefulWidget {

  @override
  _DoctorInfoCardviewWidgetState createState() =>
      _DoctorInfoCardviewWidgetState();
}

class _DoctorInfoCardviewWidgetState extends State<DoctorInfoCardviewWidget> {
  final _searchedDocController = TextEditingController();
  DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child("users").child("doctors");
  List<dynamic> lists = [];
  bool searchingFirebase = false;
  String searchedWord = "";

  //algolia instance for 'full-text-search' feature
  final Algolia algolia = AlgoliaApplication.algolia;
  List<AlgoliaObjectSnapshot> resultsAlgolia = [];
  bool searchingAlgolia = false; bool showAlgoliaResult = false;

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
                  onPressed: () =>
                      searchDoctor(_searchedDocController.text.trim()),
                  //print(_searchedDocController.text.trim()),
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
        Expanded(child: buildDoctorsListSection()),
      ],
    );
  }

  Widget buildDoctorsListSection() {
    if (showAlgoliaResult) {
      return searchedDoctorAlgoliaFutureBuilder();
    }
    //Below code commented out because we're searching in algolia index instead of firebase database
    /*if (searchingFirebase) {
      return searchedDoctorFutureBuilder();
    }*/
    return allDoctorsFutureBuilder();
  }

  Widget searchedDoctorFutureBuilder() {
    return FutureBuilder(
        future: dbRef
            .orderByChild("name")
            .startAt(searchedWord)
            .endAt(searchedWord + '\uF7FF')
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            lists.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            if (values == null) {
              return Center(child: Text("No results found"));
            }
            values.forEach((key, values) {
              lists.add(values);
            });
            return new ListView.builder(
                padding: EdgeInsets.all(2),
                shrinkWrap: true,
                itemCount: lists.length,
                itemBuilder: (_, index) {
                  return docListUI(
                      lists[index]["address"],
                      lists[index]["category"],
                      lists[index]["degrees"],
                      lists[index]["email"],
                      lists[index]["name"],
                      lists[index]["specialities"]);
                });
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget searchedDoctorAlgoliaFutureBuilder() {
    return Container(
        child: searchingAlgolia == true
            ? Center(
          child: CircularProgressIndicator(),
        )
            : resultsAlgolia.length == 0
            ? Center(
          child: Text("No results found."),
        )
            : ListView.builder(
          itemCount: resultsAlgolia.length,
          itemBuilder: (BuildContext ctx, int index) {
            AlgoliaObjectSnapshot snap = resultsAlgolia[index];

            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  (index + 1).toString(),
                ),
              ),
              title: Text(snap.data["name"]),
              subtitle: Text(snap.data["address"]),
            );
          },
        )
    );
  }

  searchAlgolia() async {
    setState(() {
      searchingAlgolia = true;
      showAlgoliaResult = true;
    });

    AlgoliaQuery query = algolia.instance.index('doctors');
    query = query.search(searchedWord);

    resultsAlgolia = (await query.getObjects()).hits;
    print(resultsAlgolia.toString());

    setState(() {
      searchingAlgolia = false;
    });
  }

  Widget allDoctorsFutureBuilder() {
    return FutureBuilder(
        future: dbRef.once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            lists.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            if (values == null) {
              return Center(child: Text("Nothing to show"));
            }
            values.forEach((key, values) {
              lists.add(values);
            });
            return new ListView.builder(
                padding: EdgeInsets.all(2),
                shrinkWrap: true,
                itemCount: lists.length,
                itemBuilder: (_, index) {
                  return docListUI(
                      lists[index]["address"],
                      lists[index]["category"],
                      lists[index]["degrees"],
                      lists[index]["email"],
                      lists[index]["name"],
                      lists[index]["specialities"]);
                });
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget docListUI(String address, String category, String degrees,
      String email, String name, String specialities) {
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
                                  onPressed: () {
                                    print(email);
                                    bookAppointment(context, email, address,
                                        specialities, name);
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

  void searchDoctor(String searchedWord) {
    if (searchedWord == "") {
      Fluttertoast.showToast(
          msg: 'Please Type Something To Search',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 14.0);
      return;
    }
    searchAlgolia();
    //Below code commented out because we're searching in algolia index instead of firebase database
    /*setState(() {
      searchingFirebase = true;
      this.searchedWord = searchedWord;
    });*/
  }

  void bookAppointment(BuildContext ctx, id, address, specialities, name) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return CreateAppointmentWidget(
          categoryId: id,
          categoryAddress: address,
          categorySpecialities: specialities,
          categoryTitle: name);
    }));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _searchedDocController.dispose();
    super.dispose();
  }

  //List<Doctor> docList = [];
  @override
  void initState() {
    super.initState();
    /*DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child('users').child('doctors');

    postsRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      doclist.clear();

      for (var individualKey in KEYS) {
        print(individualKey);
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
    });*/
  }
}
