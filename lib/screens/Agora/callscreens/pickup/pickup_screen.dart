import 'package:doctors_app/models/call.dart';
import 'package:doctors_app/screens/Agora/call_methods.dart';
import 'package:doctors_app/screens/Agora/callscreens/call_screen.dart';
import 'package:flutter/material.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  PickupScreen({@required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Incoming Call',
              style: TextStyle(
                  fontSize: 21, color: Color.fromRGBO(133, 133, 133, 52)),
            ),
            SizedBox(height: 35),
            Container(
              height: 173,
              width: 173,
              color: Colors.transparent,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Container(
                height: 143,
                width: 143,
                color: Colors.transparent,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Container(
                  height: 119,
                  width: 119,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/doctor.png'),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 35),
            Text(
              call.callerName,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 27),
            ),
            SizedBox(height: 180),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      height: 99,
                      width: 65,
                      color: Color.fromRGBO(25, 48, 79, 100),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: FlatButton(
                        child: Icon(Icons.call_end),
                        onPressed: () async {
                          await callMethods.endCall(call: call);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Decline',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(133, 133, 133, 48),
                      ),
                    )
                  ],
                ),
                SizedBox(width: 65),
                Column(
                  children: [
                    Container(
                      height: 99,
                      width: 65,
                      color: Color.fromRGBO(37, 210, 135, 100),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: FlatButton(
                        child: Icon(Icons.call),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallScreen(call: call),
                            )),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Accept',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(133, 133, 133, 48),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
