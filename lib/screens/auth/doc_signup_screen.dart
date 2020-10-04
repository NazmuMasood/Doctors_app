import 'package:algolia/algolia.dart';
import 'package:doctors_app/models/algolia.dart';
import 'package:doctors_app/screens/auth/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctors_app/screens/doctor/bottom_nav_bar/doc_bottom_navigation_tab_view.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DocSignupScreen extends StatefulWidget {
  @override
  _DocSignupScreenState createState() => _DocSignupScreenState();
}

class _DocSignupScreenState extends State<DocSignupScreen> {
  Signupmodel signupModel = Signupmodel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<bool> isSelected = [false, true];
  final DatabaseReference database =
      FirebaseDatabase.instance.reference().child('users').child('doctors');
  bool _passwordVisible = false, _confirmPasswordVisible = false;
  bool _loading = false;
  final Algolia algolia = AlgoliaApplication.algolia;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 6.0, 0.0),
                alignment: Alignment.centerRight,
                child: ToggleButtons(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        'Patient',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        'Doctor',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                  borderColor: Colors.green,
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                  borderWidth: 1,
                  highlightColor: Colors.redAccent,
                  selectedBorderColor: Colors.green,
                  selectedColor: Colors.white,
                  fillColor: Colors.green,
                  onPressed: (int index) {
                    setState(() {
                      if (!isSelected[index]) {
                        for (int i = 0; i < isSelected.length; i++) {
                          if (i == index) {
                            isSelected[i] = true;
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/signup', (Route<dynamic> route) => false);
                          } else {
                            isSelected[i] = false;
                          }
                        }
                      }
                    });
                  },
                  isSelected: isSelected,
                ),
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
                      child: Text(
                        'Signup',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(260.0, 35.0, 0.0, 0.0),
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
              Container(
                padding: EdgeInsets.only(top: 0.0, left: 30.0, right: 30.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please type your name';
                            }
                            return null;
                          },
                          onSaved: (input) => signupModel.name = input.trim(),
                          decoration: InputDecoration(
                              labelText: 'NAME',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              // hintText: 'EMAIL',
                              // hintStyle: ,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please type your degree';
                            }
                            return null;
                          },
                          onSaved: (input) => signupModel.degree = input.trim(),
                          decoration: InputDecoration(
                              labelText: 'DEGREES ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please type category';
                            }
                            return null;
                          },
                          onSaved: (input) => signupModel.category = input.trim(),
                          decoration: InputDecoration(
                              labelText: 'CATEGORIES ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please type your speciality';
                            }
                            return null;
                          },
                          onSaved: (input) => signupModel.speciality = input.trim(),
                          decoration: InputDecoration(
                              labelText: 'SPECIALITY',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please type address';
                            }
                            return null;
                          },
                          onSaved: (input) => signupModel.address = input.trim(),
                          decoration: InputDecoration(
                              labelText: 'ADDRESS ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) {
                            if (input.isEmpty || !input.contains('@')) {
                              return 'Please type an valid email';
                            }
                            return null;
                          },
                          onSaved: (input) => signupModel.email = input.trim(),
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
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please provide a password';
                            }
                            if (input.trim().length < 6) {
                              return 'Your password needs to be at-least 6 characters';
                            }
                            return null;
                          },
                          onChanged: (input) {
                            setState(() {
                              signupModel.password = input.trim();
                            });
                          },
                          onSaved: (input) => signupModel.password = input.trim(),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              labelText: 'PASSWORD ',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          obscureText: !_passwordVisible,
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please provide a password';
                            }
                            if (input != signupModel.password) {
                              return 'Your passwords don\'t match';
                            }
                            return null;
                          },
                          onChanged: (input) {
                            setState(() {
                              signupModel.confirmPassword = input.trim();
                            });
                          },
                          onSaved: (input) =>
                              signupModel.confirmPassword = input.trim(),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                              labelText: 'CONFIRM PASSWORD',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              // hintText: 'EMAIL',
                              // hintStyle: ,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          obscureText: !_confirmPasswordVisible,
                        ),
                        SizedBox(height: 20.0),
                        !_loading
                            ? Container(
                                height: 40.0,
                                child: RaisedButton(
                                  onPressed: _signupDoc,
                                  color: Colors.green,
                                  splashColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35)),
                                  child: Center(
                                    child: Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Already a member?',
                              style: TextStyle(fontFamily: 'Montserrat'),
                            ),
                            SizedBox(width: 5.0),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/logindoc');
                              },
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  //decoration: TextDecoration.underline
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20.0)
                      ],
                    )),
              )
            ])));
  }

  Future<void> _signupDoc() async {
    //form saving
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        _showProgress();
        final User user =
            (await _firebaseAuth.createUserWithEmailAndPassword(
                email: signupModel.email,
                password: signupModel.password))
                .user;
        Fluttertoast.showToast(
            msg: 'Signup Successful',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);

        addToFirebaseDatabase();
        addToAlgolia();

        _hideProgress();
        //saves user info in shared preferences
        SharedPreferencesHelper.addStringToSF('user_type', 'doctor');
        //Take user to Homepage after sign-up
        /*Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));*/
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DocBottomNavigationTabView(user)),
                (Route<dynamic> route) => false);
      } catch (e) {
        print(e.message); _hideProgress();
        Fluttertoast.showToast(
            msg: 'Signup Error',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
  }

  Future<void> addToFirebaseDatabase() async {
    try {
      await database.push().set({
        'name': signupModel.name,
        'email': signupModel.email,
        "degrees": signupModel.degree,
        "category": signupModel.category,
        "specialities": signupModel.speciality,
        "address": signupModel.address
      });
      /* Fluttertoast.showToast(
          msg: 'Firebase Data Add Successful',
          toastLength: Toast.LENGTH_SHORT);*/
    } catch (e) {
      print('Firebase Database error: ' + e.message);
      Fluttertoast.showToast(
          msg: 'Firebase Data Add Error', toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future<void> addToAlgolia() async {
    try {
      Map<String, dynamic> userModel = {
        'name' : signupModel.name,
        'email': signupModel.email,
        "degrees": signupModel.degree,
        "category": signupModel.category,
        "specialities": signupModel.speciality,
        "address": signupModel.address
      };
      //AlgoliaTask add
      AlgoliaTask taskAdded =
          await algolia.instance.index('doctors').addObject(userModel);
      if (taskAdded.data['objectID'] != null) {
        print('Algolia objectID -> ' + taskAdded.data['objectID']);
        print('Algolia added data -> ' + taskAdded.data.toString());
        /*Fluttertoast.showToast(
            msg: 'Algolia Data Add Successful',
            toastLength: Toast.LENGTH_SHORT);*/
      } else {
        Fluttertoast.showToast(
          msg: 'Algolia Data Add Error',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      print('Algolia error: ' + e.message);
      Fluttertoast.showToast(
          msg: 'Algolia Error', toastLength: Toast.LENGTH_SHORT);
    }
  }

  void _showProgress() {
    setState(() {
      _loading = true;
    });
  }

  void _hideProgress() {
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    _loading = false;
  }
}

class Signupmodel {
  String name;
  String email;
  String password;
  String confirmPassword;
  String degree;
  String category;
  String speciality;
  String address;

  Signupmodel(
      {this.name,
      this.email,
      this.password,
      this.confirmPassword,
      this.degree,
      this.category,
      this.address,
      this.speciality});
}
