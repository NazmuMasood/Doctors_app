import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogManager {

  static BuildContext _context;

  //static
  init({@required BuildContext context}) {
    _context = context;
  }

  //this method used when notification come and app is closed or in background and
  // user click on it, i will left it empty for you
  static handleDataMsg(Map<String, dynamic> data){}

  //this our method called when notification come and app is foreground
  static handleNotificationMsg(Map<String, dynamic> message) {
    debugPrint("dialogManager msg:  $message");

    final dynamic data = message['data'];
    //as ex we have some data json for every notification to know how to handle that
    //let say showDialog here so fire some action
    //bool go = true;
    //if (
    //data.containsKey('showDialog') ||
      //  go) {
      // Handle data message with dialog
      //_showDialog(data: data);
      showAlertDialog(context: _context, );
      debugPrint("okaaaaa");
    //}
  }


  static _showDialog({@required Map<String, dynamic> data}) {
    //you can use data map also to know what must show in MyDialog
    showDialog(context: _context,builder: (_) =>AlertDialog());
  }

  //show 'doctor recommendation' dialog
  static showAlertDialog({BuildContext context,
   // Map<String, dynamic> data
  }) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Not really"),
      onPressed:  () {
        print('Don\'t recommend');
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes!"),
      onPressed:  () {
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
  }

  static showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}