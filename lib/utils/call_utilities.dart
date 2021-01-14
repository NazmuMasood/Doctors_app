import 'package:doctors_app/models/call.dart';
import 'package:doctors_app/screens/Agora/call_methods.dart';
import 'package:doctors_app/screens/Agora/callscreens/call_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.displayName,
      callerPic: from.photoURL,
      receiverId: to.uid,
      receiverName: to.displayName,
      receiverPic: to.photoURL,
      channelId: randomAlphaNumeric(6),
    );
    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialed = true;

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}
