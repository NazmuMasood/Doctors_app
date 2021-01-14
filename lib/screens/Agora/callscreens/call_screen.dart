import 'package:doctors_app/models/call.dart';
import 'package:doctors_app/screens/Agora/call_methods.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  CallScreen({@required this.call});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Call has been made'),
          MaterialButton(
              color: Colors.red,
              child: Icon(Icons.call_end),
              onPressed: () {
                widget.callMethods.endCall(call: widget.call);
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
