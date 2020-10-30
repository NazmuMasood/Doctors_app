import 'package:doctors_app/screens/auth/doc_login_screen.dart';
import 'package:doctors_app/screens/auth/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DocHomeScreen extends StatelessWidget {

  DocHomeScreen({@required this.user});

  final User user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference doctorsRef = FirebaseDatabase.instance.reference().child("users").child('doctors');

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
              child: docNameFB(),
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
                  child: RaisedButton(
                    onPressed: () => _logout(context),
                    child: Text('Logout',style: TextStyle(color: Colors.redAccent),),color: Colors.white,elevation: 1,
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

  Widget docNameFB(){
    return FutureBuilder(
        future: doctorsRef.orderByChild("email").equalTo(user.email).once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> values = snapshot.data.value;
            if (values == null) {
              return Text(user.email,
                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w300, fontSize: 15),
              );
            }
            String docName;
            values.forEach((key, value) {
              docName = value['name'];
            });

            return Text(docName ?? user.email,
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w300, fontSize: 15),
            );
          }

          return SizedBox(child: CircularProgressIndicator(),
            height: MediaQuery.of(context).size.width*.035,
            width: MediaQuery.of(context).size.width*.035,);
        });
  }

  Future<void> _logout(BuildContext context) async {
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
