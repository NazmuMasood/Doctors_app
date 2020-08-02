import 'package:doctors_app/screens/auth/login.dart';
import 'package:flutter/material.dart';
import '../styles/colorScheme.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                  painter: PathPainter(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(60),
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Doctor's Appointment", style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                    ),),
                    Text("All in One touch", style: TextStyle(
                      height: 2,
                      fontSize: 22,
                      
                      fontWeight: FontWeight.w700,
                    ),)
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height*0.4,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    
                  )
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: InkWell(
                  child: Container(
                    height: 75,
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0,1],
                        colors: [getStartedColorStart,getStartedColorEnd],
                      ),
                      borderRadius: BorderRadius.circular(15)
                      
                    ),
                    child: Center(
                      child: Text(
                        "Get Started", style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class PathPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = path1Color;
    paint.style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, size.height*0.4);
    path.quadraticBezierTo(size.width*0.5, size.height*0.50, size.width*0.58, size.height*0.65);
    path.quadraticBezierTo(size.width*0.71, size.height*0.8, size.width*0.92, size.height*0.8);
    path.quadraticBezierTo(size.width*0.98, size.height*0.8, size.width, size.height*0.82);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
  
}