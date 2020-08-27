import 'package:doctors_app/models/patient.dart';
import 'package:doctors_app/screens/doctor/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Patient patient;
  Patient updatePatient;
  bool isLoading = true;
  bool firstTimeLoading = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseReference patientsRef =
      FirebaseDatabase.instance.reference().child("users").child("patients");

  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      weightController = TextEditingController(),
      ageController = TextEditingController(),
      bloodgroupController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body: /*SingleChildScrollView(
        child:*/
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(25.0, 50.0, 0.0, 0.0),
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(170.0, 21.0, 0.0, 0.0),
                child: Text(
                  '.',
                  style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              )
            ],
          ),
        ),
        Expanded(child: profileFutureBuilder()),
      ]),
      //),
    );
  }

  Widget profileFutureBuilder(){
    if(firstTimeLoading) {
      return FutureBuilder(
          future: patientsRef
              .orderByChild('email')
              .equalTo(widget.user.email)
              .once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData) {
              Map<dynamic, dynamic> values = snapshot.data.value;
              print('Downloaded snapshot -> ' + snapshot.data.value.toString());
              /*if (values == null) {
                return RefreshIndicator(
                  onRefresh: refresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      child: Center(child: Text('Profile not available')),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height - 300,
                    ),
                  ),
                );
              }
              firstTimeLoading = false;
              values.forEach((key, values) {
                patient = Patient.fromMap(values);
              });*/
              patient = Patient(
                  name: "abc name", email: 'bc @email.com', age: 'c 33', weight: 'd 20kg', bloodgroup: 'e ab+');
              print('Patient info -> ' +
                  patient.email.toString());
              return RefreshIndicator(
                onRefresh: refresh,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(child: Text(patient.name)),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 300,
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          });
    }
    return profileContainer(patient);
  }

  Widget profileContainer(Patient patient){
    return RefreshIndicator(
      onRefresh: refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(top: 0.0, left: 30.0, right: 30.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
              color: Colors.white38,
              border: Border.all(
                color: Colors.greenAccent,
                width: 2,
              )),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    //controller: nameController,
                    onSaved: (input) => input = updatePatient.name,
                    initialValue: patient?.name,
                    decoration: InputDecoration(
                        labelText: 'NAME',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    validator: (input) {
                      if (input.isEmpty) {
                        //return 'Please type an name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    //controller: emailController,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please type an email';
                      }
                      return null;
                    },
                    onSaved: (input) => input = updatePatient.email,
                    initialValue: patient?.email,
                    decoration: InputDecoration(
                        labelText: 'EMAIL ',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    //controller: weightController,
                    validator: (input) {
                      if (input.isEmpty) {
                        //return 'Please enter your weight';
                      }
                      return null;
                    },
                    initialValue: patient?.weight,
                    onSaved: (input) =>
                    updatePatient.weight = input.trim(),
                    decoration: InputDecoration(
                        labelText: 'WEIGHT ',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    //controller: ageController,
                    validator: (input) {
                      if (input.isEmpty) {
                        //return 'Please type age';
                      }
                      return null;
                    },
                    initialValue: patient?.age,
                    onSaved: (input) => updatePatient.age = input.trim(),
                    decoration: InputDecoration(
                        labelText: 'AGE ',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    //controller: bloodgroupController,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please type blood group';
                      }
                      return null;
                    },
                    initialValue: patient?.bloodgroup,
                    onSaved: (input) => input = updatePatient.bloodgroup,
                    decoration: InputDecoration(
                        labelText: 'BLOOD GROUP ',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: updateProfile,
                      color: Colors.green,
                      splashColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                        child: Text(
                          'UPDATE',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              )),
          /*child: Column(
                        children: <Widget>[
                          TextField(autofillHints: ['hello','mello'], controller: nameController, enabled: false,)
                        ],
                      )*/
        ),
      ),
    );
  }

  Future<void> updateProfile() async {}

  Future<void> getUser() async {
    print('refresh mail '+widget.user.email);
    try {
      await patientsRef
          .orderByChild('email')
          .equalTo(widget.user.email)
          .once()
          .then((DataSnapshot snapshot) {
        print('Downloaded snapshot of user : ${snapshot.value}');
        setState(() {
          patient = Patient.fromMap(snapshot.value);
          nameController.text = patient.name;
          emailController.text = patient.email;
          ageController.text = patient.age;
          weightController.text = patient.weight;
          bloodgroupController.text = patient.bloodgroup;
          isLoading = false;
        });
      });
    } catch (e) {
      print(e.message);
    }
  }

  /*void setupTextControllers(){
    nameController = TextEditingController(text: patient.name);
    emailController = TextEditingController(text: patient.email);
    ageController = TextEditingController(text: patient.age);
    weightController = TextEditingController(text: patient.weight);
    bloodgroupController = TextEditingController(text: patient.bloodgroup);
  }*/

  @override
  void initState() {
    super.initState();
    /*patient = Patient(
        name: "a", email: 'b', age: '33', weight: '20kg', bloodgroup: 'ab+');*/
    //print('name -> ' + patient.name);
    /*setState(() {
      nameController.text = patient.name;
    });*/
    //setupTextControllers();
    /* setState(() {
      isLoading = false;
      print('name -> '+patient.name);
    });*/
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1), () => "1 second");
    setState(() {
      firstTimeLoading = true;
    });
    //getUser();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
