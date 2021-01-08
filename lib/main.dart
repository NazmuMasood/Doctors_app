import 'package:doctors_app/screens/auth/login_screen.dart';
import 'package:doctors_app/screens/auth/doc_login_screen.dart';
import 'package:doctors_app/screens/auth/doc_signup_screen.dart';
import 'package:doctors_app/screens/auth/shared_preferences.dart';
import 'package:doctors_app/screens/doctor/bottom_nav_bar/doc_bottom_navigation_tab_view.dart';
import 'package:doctors_app/screens/patient/user_profile/user_profile_screen.dart';
import 'package:doctors_app/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/screens/auth/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'screens/patient/bottom_nav_bar/bottom_navigation_tab_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        // builder: DevicePreview.appBuilder,
        // initialRoute: '/',
        builder: (context, _) => ResponsiveWrapper.builder(_,
            maxWidth: 1200,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
        routes: {
          '/': (context) => AuthenticatorScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/logindoc': (context) => DocLoginScreen(),
          '/signupdoc': (context) => DocSignupScreen(),
          '/userprofile': (context) => UserProfileScreen(
                user: null,
              ),
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
      ),
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
    User user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return WelcomeScreen();
    }
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
