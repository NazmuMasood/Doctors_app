import 'package:flutter/material.dart';
import 'package:doctors_app/widgets/patient/doctor_info_cardview.dart';
import 'package:doctors_app/screens/patient/Nothing.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DoctorScreen extends StatelessWidget {
//  final String categoryId;
//  final String categoryTitle;
//  DoctorScreen(this.categoryId,this.categoryTitle);
  static const routeName  ='/category-doctorScreen';
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String,String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];
    //final listDoctors = dummy_doctors.toList();
    return Scaffold(
      /*appBar: AppBar(
        title: Text(categoryTitle,style: TextStyle(color: Colors.teal),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),*/
      body:  categoryTitle=='Doctors'?DoctorInfoCardViewWidget():Nothing(),
    );
  }
}