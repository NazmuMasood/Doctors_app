import 'package:doctors_app/screens/auth/shared_preferences.dart';
import 'package:doctors_app/screens/doctor/bottom_nav_bar/doc_bottom_navigation_tab_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DocLoginScreen extends StatefulWidget {
  @override
  _DocLoginScreenState createState() => _DocLoginScreenState();
}

class _DocLoginScreenState extends State<DocLoginScreen> {
  String _email, _password;
  List<bool> isSelected = [false, true];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _loading = false;

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
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 60.0, 6.0, 0.0),
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
                                    '/login', (Route<dynamic> route) => false);
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
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Hello',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                    child: Text('Doctor',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(255.0, 175.0, 0.0, 0.0),
                    child: Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Form(
                    //form
                    key: _formKey, //formkey
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'EMAIL',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          validator: (input) {
                            if (input.isEmpty|| !input.contains('@')) {
                              return 'Please type an valid email';
                            }
                            return null;
                          },
                          onSaved: (input) => _email = input.trim(),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
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
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          //ignore: missing_return
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please provide a password';
                            }
                            if (input.length < 6) {
                              return 'Your password needs to be at-least 6 characters';
                            }
                          },
                          onSaved: (input) => _password = input.trim(),
                          obscureText: !_passwordVisible,
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          alignment: Alignment(1.0, 0.0),
                          padding: EdgeInsets.only(top: 15.0, left: 20.0),
                          child: InkWell(
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                //decoration: TextDecoration.underline
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        !_loading
                            ? Container(
                                height: 40.0,
                                child: RaisedButton(
                                  onPressed: _loginDoc,
                                  color: Colors.green,
                                  splashColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35)),
                                  child: Center(
                                    child: Text(
                                      'LOGIN',
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
                      ],
                    ))),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'No account?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signupdoc');
                  },
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      //decoration: TextDecoration.underline
                    ),
                  ),
                )
              ],
            )
          ],
        )));
  }

  Future<void> _loginDoc() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        _showProgress();

        //Firstly, check if patient exists with that email
        DatabaseReference doctorsRef = FirebaseDatabase.instance
            .reference()
            .child('users')
            .child('doctors');
        doctorsRef
            .orderByChild('email')
            .equalTo(_email)
            .once()
            .then((DataSnapshot snap) {
          var values = snap.value;
          if (values == null) {
            _hideProgress();
            print('No doctor with that email');
            Fluttertoast.showToast(
                msg: 'Login Error',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.teal,
                textColor: Colors.white,
                fontSize: 14.0);
          }
          //Secondly, authenticate
          else {
            _authenticate();
          }
        });
        
      } catch (e) {
        print(e.message);
        _hideProgress();
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

  Future<void> _authenticate() async{
    try{
      User user = (await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password))
          .user;
      _hideProgress();
      //saves user info in shared preferences
      SharedPreferencesHelper.addStringToSF('user_type', 'doctor');

      FirebaseMessaging firebaseMessaging = FirebaseMessaging();
      String fcmToken = await firebaseMessaging.getToken();
      print('fcmToken -> '+fcmToken);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DocBottomNavigationTabView(user)),
              (Route<dynamic> route) => false);
    }catch (e) {
      print(e.message);
      _hideProgress();
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
    _passwordVisible = false;
    _loading = false;
    super.initState();
  }
}
