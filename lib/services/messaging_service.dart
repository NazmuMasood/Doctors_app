import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class MessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        if(message['data']['showDialog'] != 'true') {
          showTopNotification(message);
        }else{
          showRecommendationDialog(message['data']['apptKey']);
          print('apptKey ${message['data']['apptKey']}');
        }
        //DialogManager.handleNotificationMsg(message);
      }, //onMessage
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showRecommendationDialog(message['data']['apptKey']);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showRecommendationDialog(message['data']['apptKey']);
      },
    );
  }

  static Future<dynamic> myBackgroundMessageHandler (Map<String, dynamic> message) async {
    print('myBgMsgHandler: ' + message.toString());

    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  void showTopNotification(Map<String, dynamic> message) {
    //Custom notification top-overlay for foreground messages
    showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: SafeArea(
          child: ListTile(
            leading: SizedBox.fromSize(
                size: const Size(40, 40),
                child: CircleAvatar(
                  radius: 37,
                  backgroundImage: AssetImage('assets/images/doctor.png'),
                )),
            title: Text(message['notification']['title']),
            subtitle: Text(message['notification']['body']),
            trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  OverlaySupportEntry.of(context).dismiss();
                }),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 5000));
  }

  //show 'doctor recommendation' dialog
  void showRecommendationDialog(String apptKey) {
    showOverlayNotification((context) {
      return AlertDialog(
        title: Text("Appointment Finished"),
        content: Text("Would like to recommend the Doctor?"),
        actions: [
          FlatButton(
            child: Text("Not really"),
            onPressed: () {
              print('Don\'t recommend');
              uploadRating(apptKey: apptKey, awesome: 'n');
              OverlaySupportEntry.of(context).dismiss();                },
          ),
          FlatButton(
            child: Text("Yes!"),
            onPressed: () {
              print('Recommend');
              uploadRating(apptKey: apptKey, awesome: 'y');
              OverlaySupportEntry.of(context).dismiss();                },
          )
        ],
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.red)),
        elevation: 5,
      );
    },
        position: NotificationPosition.bottom,
        duration: Duration(minutes: 5)
    );
  }

  void uploadRating({String apptKey, String awesome}){
    DatabaseReference appointmentsRef = FirebaseDatabase.instance.reference().child("appointments");
    try {
      appointmentsRef.child(apptKey).child('r').set(awesome).then((_) {
        print("Rating upload successful");
      });
    }catch (e) {
      print('Rating upload error ->' + e.message);}
  }

  //show 'doctor recommendation' dialog
  /*static showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Not really"),
      onPressed: () {
        print('Don\'t recommend');
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes!"),
      onPressed: () {
        print('Recommend');
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Appointment Finished"),
      content: Text("Would like to recommend the Doctor?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }*/
}
