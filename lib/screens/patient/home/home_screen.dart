import 'package:doctors_app/screens/auth/shared_preferences.dart';
import 'package:doctors_app/services/messaging_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/screens/patient/home/home_gridview_items_widget.dart';
import 'package:doctors_app/dummy/category_data.dart';
import 'package:doctors_app/screens/auth/login_screen.dart';
import 'package:flutter/scheduler.dart';
import 'package:overlay_support/overlay_support.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Messaging service for receiving push notification
  final MessagingService _messagingService = MessagingService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//    int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: Text(
                widget.user.email,
                style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w300,
                    fontSize: 17),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.teal,
                  ),
                  Text(
                    '329 Momin Road',
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 8, 0),
              child: Row(children: <Widget>[
                ButtonTheme(
                  height: 32,
                  minWidth: 53,
                  child: RaisedButton(
                    onPressed: _logout,
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.redAccent,fontSize: 16),
                    ),
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: Colors.redAccent,
                      size: 28,
                    ),
                    onPressed: () => null),
              ])),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: GridView(
          children: DUMMY_CATEGORIES
              .map(
                (catData) => CategoryItemWidget(
                    catData.id, catData.title, catData.avatar, catData.text),
              )
              .toList(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 1.3,
            crossAxisSpacing: 0,
            mainAxisSpacing: 5,
          ),
        ),
      ),
//       bottomNavigationBar: BottomNavigationBar(
//        items: const <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//            icon: Icon(Icons.home),
//            title: Text('Home'),
//          ),
//
//          BottomNavigationBarItem(
//            icon: Icon(Icons.dashboard),
//            title: Text('profile'),
//          ),
//        ],
//        currentIndex: _selectedIndex,
//        selectedItemColor: Colors.amber[800],
//        onTap: _onItemTapped,
//      ),
    );
  }

  _logout() async {
    DatabaseReference patientsRef = FirebaseDatabase.instance.reference().child('users').child('patients');
    await patientsRef.orderByChild('email').equalTo(widget.user.email).once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var values = snap.value;
      for (var key in keys){
        print(key.toString()+" | "+values[key]['email'].toString());
        patientsRef.child(key).child('fcmToken').remove().then((_){
          print("Deleted fcmToken of "+values[key]['email'].toString()+" successful");
        });
      }
    });

    await _firebaseAuth.signOut().then((_) {
      try {
        SharedPreferencesHelper.addStringToSF('user_type', 'patient_logout');
        print('Logging out user successful');
        //      Navigator.of(context)
        //        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return LoginScreen();
            },
          ),
          (_) => false,
        );
      } catch (e) {
        print('Shared preferences logout error ->' + e.message);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _messagingService.initialise();
    checkIfRatingDue();
  }

  Future<void> checkIfRatingDue() async{
    DatabaseReference patientsRef = FirebaseDatabase.instance.reference().child("users").child('patients');
    patientsRef.orderByChild('email').equalTo(widget.user.email).once().then((DataSnapshot snap) {
      Map values = snap.value;
      //print('ratingDueChecker: values- '+values.toString());
      values.forEach((key, value) {
        if(value['rDue'] != null){
          print('!!! rating koro !!!');
          showRecommendationDialog(apptKey: value['rDue'], pKey: key);
        }
      });
    });
  }

  //show 'doctor recommendation' dialog
  void showRecommendationDialog({String apptKey, String pKey}) {
    showOverlayNotification((context) {
      return AlertDialog(
        title: Text("Appointment Finished"),
        content: Text("Would like to recommend the Doctor?"),
        actions: [
          FlatButton(
            child: Text("Not really"),
            onPressed: () {
              print('Don\'t recommend');
              uploadRating(apptKey: apptKey, awesome: 'n', pKey: pKey);
              OverlaySupportEntry.of(context).dismiss();
            }),
          FlatButton(
            child: Text("Yes!"),
            onPressed: () {
              print('Recommend');
              uploadRating(apptKey: apptKey, awesome: 'y', pKey: pKey);
              OverlaySupportEntry.of(context).dismiss();
            })
        ],
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.red)),
        elevation: 5,
      );
    },
        position: NotificationPosition.bottom,
        duration: Duration(minutes: 5)
    );
  }

  void uploadRating({String apptKey, String awesome, String pKey}){
    DatabaseReference appointmentsRef = FirebaseDatabase.instance.reference().child("appointments");
    try {
      appointmentsRef.child(apptKey).child('r').set(awesome).then((_) {
        print("Rating upload successful");

        DatabaseReference patientsRef = FirebaseDatabase.instance.reference().child("users").child('patients');
        patientsRef.child(pKey).child('rDue').remove().then((_){
          print('rDue removed from pKey- $pKey');
        });

      });
    }catch (e) {
      print('Rating upload or rDue remove error ->' + e.message);}
  }

//  void _onItemTapped(int index) {
//    setState(() {
//      if( index ==0){
//        Navigator.of(context)
//          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
//      }
//      else {
//        Navigator.of(context)
//          .pushNamedAndRemoveUntil('/user', (Route<dynamic> route) => false);
//      }
//      _selectedIndex = index;
//    });
//  }


}
