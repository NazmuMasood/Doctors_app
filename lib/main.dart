import 'package:doctors_app/screens/auth/login_screen.dart';
import 'package:doctors_app/screens/auth/doc_login_screen.dart';
import 'package:doctors_app/screens/auth/doc_signup_screen.dart';
import 'package:doctors_app/screens/auth/shared_preferences.dart';
import 'package:doctors_app/screens/doctor/bottom_nav_bar/doc_bottom_navigation_tab_view.dart';
import 'package:doctors_app/screens/patient/user_profile/user_profile_screen.dart';
import 'package:doctors_app/screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/screens/auth/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/patient/bottom_nav_bar/bottom_navigation_tab_view.dart';

void main() {
  runApp(DevicePreview(enabled: false, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.of(context).locale,
      // <--- Add the locale
      builder: DevicePreview.appBuilder,
      // <--- Add the builder
      initialRoute: '/',
      routes: {
        '/': (context) => AuthenticatorScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/logindoc': (context) => DocLoginScreen(),
        '/signupdoc': (context) => DocSignupScreen(),
        '/userprofile': (context) => UserProfileScreen(),
//        DoctorScreen.routeName:(ctx) => DoctorScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Doctor\'s App',
      theme: ThemeData(
        fontFamily: 'Avenir',
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: HomeView(), // Removed because clash with the route properties
    );
  }
}

class AuthenticatorScreen extends StatefulWidget {
  @override
  _AuthenticatorScreenState createState() => _AuthenticatorScreenState();
}

class _AuthenticatorScreenState extends State<AuthenticatorScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data;
            return FutureBuilder<String>(
              future: SharedPreferencesHelper.getStringValueSF('user_type'),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  print('user_type-> ' + snapshot.data.toString());
                  if (snapshot.data == 'patient') {
                    return BottomNavigationTabView(user);
                  }
                  if (snapshot.data == 'doctor') {
                    return DocBottomNavigationTabView(user);
                  }
                  if (snapshot.data == 'patient_logout') {
                    return LoginScreen();
                  }
                  if (snapshot.data == 'doctor_logout') {
                    return DocLoginScreen();
                  }
                  return WelcomeScreen();
                }
                return WelcomeScreen();
              },
            );
            /// is because there is user already logged
            //return BottomNavigationTabView(user);
            /// !!!!!!!!! doctor gets logged in as patient !!!! handle it ASAP
          }

          /// other way there is no user logged.
          return WelcomeScreen();
        });
    /*return Scaffold(
      appBar: AppBar(
        title: Text('Doctor\'s App'),
      ),
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
              child: Text('Login')
            ),
            RaisedButton(
                onPressed: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                },
                child: Text('Sign Up')
            ),
          ],
        ),
      ),
    );*/
  }
}
