import 'package:doctors_app/screens/auth/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/screens/patient/home/home_gridview_items_widget.dart';
import 'package:doctors_app/dummy/category_data.dart';
import 'package:doctors_app/screens/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, @required this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//    int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 8, 0, 0),
              child: Text(
                widget.user.email,
                style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 13,
                  color: Colors.teal,
                ),
                Text(
                  '329 Momin Road',
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 11,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Row(children: <Widget>[
                ButtonTheme(
                  height: 28,
                  minWidth: 50,
                  child: RaisedButton(
                    onPressed: _logout,
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => null),
              ])),
        ],
      ),
      body: GridView(
        children: DUMMY_CATEGORIES
            .map(
              (catData) => CategoryItemWidget(
                  catData.id, catData.title, catData.avatar, catData.text),
            )
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 1.3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 5,
        ),
      ),
//       bottomNavigationBar: BottomNavigationBar(
//        items: const <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//            icon: Icon(Icons.home),
//            title: Text('Home'),
//          ),
//
//          BottomNavigationBarItem(
//            icon: Icon(Icons.dashboard),
//            title: Text('profile'),
//          ),
//        ],
//        currentIndex: _selectedIndex,
//        selectedItemColor: Colors.amber[800],
//        onTap: _onItemTapped,
//      ),
    );
  }

  _logout() async {
    await _firebaseAuth.signOut().then((_) {
      try {
        SharedPreferencesHelper.addStringToSF('user_type', 'patient_logout');
        print(
            'Logging out -> firebase logout success, shared_pref logout success');
        //      Navigator.of(context)
        //        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return LoginScreen();
            },
          ),
          (_) => false,
        );
      } catch (e) {
        print('Shared preferences logout error ->' + e.message);
      }
    });
  }
//  void _onItemTapped(int index) {
//    setState(() {
//      if( index ==0){
//        Navigator.of(context)
//          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
//      }
//      else {
//        Navigator.of(context)
//          .pushNamedAndRemoveUntil('/user', (Route<dynamic> route) => false);
//      }
//      _selectedIndex = index;
//    });
//  }
}
