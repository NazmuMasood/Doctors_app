import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/screens/patient/doctor_screen.dart';
class CategoryItemWidget extends StatelessWidget {
  final String title;
  final Widget avatar;
  final String text;
  final String id;

  CategoryItemWidget(this.id,this.title,this.avatar,this.text);
  void selectCategory(BuildContext ctx){
    Navigator.of(ctx).pushNamed(DoctorScreen.routeName,arguments: {
      'id' :id,'title':title,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.fromLTRB(18, 20, 18, 0),
      child: InkWell(
        onTap: () {
          selectCategory(context);
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
                  height: 45,
                  width: 45,
                  child: avatar,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(title,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 18),),
                SizedBox(
                  height: 3,
                ),
                Text(text,style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
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