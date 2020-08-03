import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/widgets/patient/category_item.dart';
import 'package:doctors_app/dummy/category_data.dart';
import 'package:doctors_app/widgets/patient/category_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, @required this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: 13,
                      color: Colors.teal,
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w300,
                          fontSize: 13),
                    ),
                  ],
                ),
                Text(
                  '329 Momin Road',
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                )
              ],
            )
            //Text('Icon',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),),
            ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Row(children: <Widget>[
                RaisedButton(onPressed: _logout, child: Text('Logout')),
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
    );
    /*return Scaffold(
      appBar: AppBar(
        title: Text('Home - ${widget.user.email}'),
      ),
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: (){
                  _logout();
                },
                child: Text('Logout')
            ),
          ],
        ),
      ),
    );*/
  }

  _logout() async {
    await _firebaseAuth.signOut().then((_) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    });
  }
}
