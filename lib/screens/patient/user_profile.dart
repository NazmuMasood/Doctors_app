import 'package:doctors_app/models/patient.dart';
import 'package:doctors_app/screens/doctor/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Patient patient;  List<dynamic> keys = [];
  Patient updatePatient = Patient();
  bool isLoading = false;

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
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(25.0, 50.0, 0.0, 0.0),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 50.0, fontWeight: FontWeight.bold),
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

  DatabaseReference appointmentsRef =
      FirebaseDatabase.instance.reference().child("appointments");

  Widget profileFutureBuilder() {
    return FutureBuilder(
        future:
            patientsRef.orderByChild('email').equalTo(widget.user.email).once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            keys.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            print('Downloaded snapshot -> ' + snapshot.data.value.toString());
            if (values == null) {
              return RefreshIndicator(
                onRefresh: refresh,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(child: Text('Profile not available')),
                    height: MediaQuery.of(context).size.height - 300,
                  ),
                ),
              );
            }
            values.forEach((key, values) {
              keys.add(key);
              patient = Patient.fromMap(values);
            });
            print('Key -> ' + keys[0].toString());
            print('Patient info -> ' + patient.email.toString());
            setupTextControllers();
            /*return RefreshIndicator(
                onRefresh: refresh,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(child: Text(nameController.text)),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 300,
                  ),
                ),
              );*/
            return profileContainer(patient);
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget profileContainer(Patient patient) {
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
                    controller: nameController,
                    onSaved: (input) => updatePatient.name = input.trim(),
                    //initialValue: patient?.name,
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
                        return 'Please type an name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please type an email';
                      }
                      return null;
                    },
                    enabled: false,
                    onSaved: (input) => updatePatient.email = input.trim(),
                    //initialValue: patient?.email,
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
                    controller: weightController,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please enter your weight';
                      }
                      return null;
                    },
                    //initialValue: patient?.weight,
                    onSaved: (input) => updatePatient.weight = input.trim(),
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
                    controller: ageController,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please type age';
                      }
                      return null;
                    },
                    //initialValue: patient?.age,
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
                    controller: bloodgroupController,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please type blood group';
                      }
                      return null;
                    },
                    //initialValue: patient?.bloodgroup,
                    onSaved: (input) => updatePatient.bloodgroup = input.trim(),
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
                  isLoading ? Container(
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
                  ) : Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.blue),
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              )),
        ),
      ),
    );
  }

  void setupTextControllers(){
      nameController.text = patient.name;
      emailController.text = patient.email;
      ageController.text = patient.age!=null ? patient.age : '';
      weightController.text = patient.weight!=null ? patient.weight : '';
      bloodgroupController.text = patient.bloodgroup!=null ? patient.bloodgroup : '';
  }

  Future<void> updateProfile() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      ///Update firebase node here
      setState(() {
        isLoading = true;
      });
      try {
        await Future.delayed(const Duration(seconds: 1), () => "1 second");
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: 'Update Successful',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      } catch (e) {
        print(e.message);
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: 'Login Error',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }
      }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1), () => "1 second");
    setState(() {keys.clear();});
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    weightController.dispose();
    bloodgroupController.dispose();
    super.dispose();
  }
}
