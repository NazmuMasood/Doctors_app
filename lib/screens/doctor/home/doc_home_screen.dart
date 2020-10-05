import 'package:doctors_app/screens/auth/doc_login_screen.dart';
import 'package:doctors_app/screens/auth/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DocHomeScreen extends StatefulWidget {
  const DocHomeScreen({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  _DocHomeScreenState createState() => _DocHomeScreenState();
}

class _DocHomeScreenState extends State<DocHomeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 8, 0, 0),
              child: Text(
                widget.user.email,
                style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 13,
                  color: Colors.teal,
                ),
                Text(
                  '329 Momin Road',
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 11,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Row(children: <Widget>[
                ButtonTheme(
                  height: 28,
                  minWidth: 50,
                  child: RaisedButton(onPressed: _logout,child: Text('Logout',style: TextStyle(color: Colors.redAccent),),color: Colors.white,elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),),),
                IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => null),
              ])),
        ],
      ),
      body: Center(child: Text('Doctor Home Page'))
    );
  }

  _logout() async {
    await _firebaseAuth.signOut().then((_) {
      try {
        SharedPreferencesHelper.addStringToSF('user_type', 'doctor_logout');
        print(
            'Logging out -> firebase logout success, shared_pref logout success');
        //      Navigator.of(context)
        //        .pushNamedAndRemoveUntil('/logindoc', (Route<dynamic> route) => false);
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return DocLoginScreen();
            },
          ),
              (_) => false,
        );
      } catch (e) {
        print('Shared preferences logout error ->' + e.message);
      }
    });
  }
}