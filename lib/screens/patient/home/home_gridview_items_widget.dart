import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/screens/patient/search_doctor/search_doctor_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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
          pushNewScreenWithRouteSettings(
            context,
            settings: RouteSettings(name: SearchDoctorScreen.routeName,arguments:{
              'id' :id,'title':title,
            }),
            screen: SearchDoctorScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
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
}