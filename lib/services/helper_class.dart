import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as toaster;
import 'package:overlay_support/overlay_support.dart';

class HelperClass{
  static showToast(String msg) {
    toaster.Fluttertoast.showToast(
        msg: msg,
        toastLength: toaster.Toast.LENGTH_LONG,
        gravity: toaster.ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 14.0
    );
  }

  //show 'doctor recommendation' dialog
  static showRecommendationDialog({String apptKey, String pKey}) {
    showOverlayNotification((context) {
      /*return AlertDialog(
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
      */
      return Card(
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
                            'Your appointment was successful !',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Would you like to recommend the Doctor?',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Expanded(
                  child:Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child:
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 10, 4),
                                width: 150,
                                height: 35,
                                child: RaisedButton(
                                  onPressed: () {
                                    print('Don\'t recommend');
                                    uploadRating(apptKey: apptKey, awesome: 'n', pKey: pKey);
                                    OverlaySupportEntry.of(context).dismiss();
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(
                                          color:
                                          Color.fromRGBO(28, 222, 187, 1))),
                                  child: Text(
                                    'Not Really',
                                    style: TextStyle(
                                      color: Colors.teal[600],
                                    ),
                                  ),
                                ),
                              ),),
                            Container(
                              height: 35,
                              width: 240,
                              padding: EdgeInsets.fromLTRB(3, 0, 0, 5),
                              child: RaisedButton(
                                onPressed: () {
                                  print('Recommend');
                                  uploadRating(apptKey: apptKey, awesome: 'y', pKey: pKey);
                                  OverlaySupportEntry.of(context).dismiss();
                                },
                                color: Colors.teal[400],
                                //Color.fromRGBO(28, 222, 187, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Yes!',
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
                  ),),
              ],
            ),
          ));
    },
        position: NotificationPosition.bottom,
        duration: Duration(seconds: 60)
    );
  }

  static uploadRating({String apptKey, String awesome, String pKey}){
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

}