import 'package:doctors_app/screens/patient/tele_doctor.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/screens/patient/search_doctor/doctor_info_cardview_widget.dart';

class SearchDoctorScreen extends StatelessWidget {
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
      body:  categoryTitle=='Doctors'?DoctorInfoCardViewWidget():categoryTitle=='Tele Doctor'?TeleDoctor():Center(child: Container( child: Text('Available Soon'),)),
    );
  }
}