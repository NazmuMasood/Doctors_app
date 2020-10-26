import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HelperClass{
  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 14.0
    );
  }
}