import 'package:doctors_app/services/helper_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/screens/patient/search_doctor/search_doctor_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CategoryItemWidget extends StatefulWidget {
  final String title;
  final Widget avatar;
  final String text;
  final String id;

  CategoryItemWidget(this.id,this.title,this.avatar,this.text);
//  void selectCategory(BuildContext ctx){
//    RouteSettings(name: DoctorScreen.routeName,arguments:{
//    'id' :id,'title':title,
//    });
//    screen:DoctorScreen();
//    withNavBar: true;
//    pageTransitionAnimation: PageTransitionAnimation.cupertino;
////    Navigator.of(ctx).pushNamed(DoctorScreen.routeName,arguments: {
////      'id' :id,'title':title,
////    });
//  }

  @override
  _CategoryItemWidgetState createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.fromLTRB(19, 20, 19, 1.5),
      child: InkWell(
        onTap: () {
          print(widget.id);
          // checkIfRatingDue(context);
          pushNewScreenWithRouteSettings(
            context,
            settings: RouteSettings(name: SearchDoctorScreen.routeName,arguments:{
              'id' :widget.id,'title':widget.title,
            }),
            screen: SearchDoctorScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        splashColor: Colors.tealAccent,
        borderRadius: BorderRadius.circular(9),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          elevation: 6,
          shadowColor: Color.fromRGBO(58, 199, 172, .6),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 52,
                  width: 52,
                  child: widget.avatar,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 23),),
                SizedBox(
                  height: 4,
                ),
                Text(widget.text,style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.blueGrey,
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkIfRatingDue(BuildContext context) async{
    User user = FirebaseAuth.instance.currentUser;
    DatabaseReference patientsRef = FirebaseDatabase.instance.reference().child("users").child('patients');
    patientsRef.orderByChild('email').equalTo(user.email).once().then((DataSnapshot snap) {
      Map values = snap.value;
      //print('ratingDueChecker: values- '+values.toString());
      values.forEach((key, value) {
        if(value['rDue'] != null){
          print('!!! rating koro !!!');
          showRecommendationDialog(apptKey: value['rDue'], pKey: key);
        }
        else{
          pushNewScreenWithRouteSettings(
            context,
            settings: RouteSettings(name: SearchDoctorScreen.routeName,arguments:{
              'id' :widget.id,'title':widget.title,
            }),
            screen: SearchDoctorScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }
      });
    });
  }

  //show 'doctor recommendation' dialog
  void showRecommendationDialog({String apptKey, String pKey}) {
    showOverlayNotification((context) {
      return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            height: 146,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        child: Image(
                          image: AssetImage('assets/images/doctor.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Your appointment was successful !',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Would you like to recommend the Doctor?',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Expanded(
                  child:Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child:
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 10, 4),
                                width: 150,
                                height: 35,
                                child: RaisedButton(
                                  onPressed: () {
                                    print('Don\'t recommend');
                                    uploadRating(apptKey: apptKey, awesome: 'n', pKey: pKey);
                                    OverlaySupportEntry.of(context).dismiss();
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(
                                          color:
                                          Color.fromRGBO(28, 222, 187, 1))),
                                  child: Text(
                                    'Not Really',
                                    style: TextStyle(
                                      color: Colors.teal[600],
                                    ),
                                  ),
                                ),
                              ),),
                            Container(
                              height: 35,
                              width: 240,
                              padding: EdgeInsets.fromLTRB(3, 0, 0, 5),
                              child: RaisedButton(
                                onPressed: () {
                                  print('Recommend');
                                  uploadRating(apptKey: apptKey, awesome: 'y', pKey: pKey);
                                  OverlaySupportEntry.of(context).dismiss();
                                },
                                color: Colors.teal[400],
                                //Color.fromRGBO(28, 222, 187, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Yes!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),),
              ],
            ),
          ));
    },
        position: NotificationPosition.bottom,
        duration: Duration(seconds: 5)
    );
  }

  void uploadRating({String apptKey, String awesome, String pKey}){
    DatabaseReference appointmentsRef = FirebaseDatabase.instance.reference().child("appointments");
    try {
      appointmentsRef.child(apptKey).child('r').set(awesome).then((_) {
        print("Rating upload successful");

        DatabaseReference patientsRef = FirebaseDatabase.instance.reference().child("users").child('patients');
        patientsRef.child(pKey).child('rDue').remove().then((_){
          print('rDue removed from pKey- $pKey');
        });

      });
    }catch (e) {
      print('Rating upload or rDue remove error ->' + e.message);}
  }
}

/*
class CategoryItemWidget extends StatelessWidget {
  final String title;
  final Widget avatar;
  final String text;
  final String id;

  CategoryItemWidget(this.id,this.title,this.avatar,this.text);
//  void selectCategory(BuildContext ctx){
//    RouteSettings(name: DoctorScreen.routeName,arguments:{
//    'id' :id,'title':title,
//    });
//    screen:DoctorScreen();
//    withNavBar: true;
//    pageTransitionAnimation: PageTransitionAnimation.cupertino;
////    Navigator.of(ctx).pushNamed(DoctorScreen.routeName,arguments: {
////      'id' :id,'title':title,
////    });
//  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.fromLTRB(19, 20, 19, 1.5),
      child: InkWell(
        onTap: () {
          checkIfRatingDue(context);
          print(id);
        },
        splashColor: Colors.tealAccent,
        borderRadius: BorderRadius.circular(9),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          elevation: 6,
          shadowColor: Color.fromRGBO(58, 199, 172, .6),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 52,
                  width: 52,
                  child: avatar,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(title,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 23),),
                SizedBox(
                  height: 4,
                ),
                Text(text,style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.blueGrey,
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkIfRatingDue(BuildContext context) async{
    User user = FirebaseAuth.instance.currentUser;
    DatabaseReference patientsRef = FirebaseDatabase.instance.reference().child("users").child('patients');
    patientsRef.orderByChild('email').equalTo(user.email).once().then((DataSnapshot snap) {
      Map values = snap.value;
      //print('ratingDueChecker: values- '+values.toString());
      values.forEach((key, value) {
        if(value['rDue'] != null){
          print('!!! rating koro !!!');
          HelperClass.showRecommendationDialog(apptKey: value['rDue'], pKey: key);
        }
        else{
          pushNewScreenWithRouteSettings(
            context,
            settings: RouteSettings(name: SearchDoctorScreen.routeName,arguments:{
              'id' :id,'title':title,
            }),
            screen: SearchDoctorScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }
      });
    });
  }
}*/
