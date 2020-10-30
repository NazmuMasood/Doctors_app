import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class Appointment {
  String pId;
  String dId;
  String date;
  String timeSlot;
  String flag;
  String dHelper;
  String pHelper;
  String dHelperFull;
  int createdAt;
  String apptId;
  String calDHelper;
  String calPHelper;

  Appointment({this.pId, this.dId, this.timeSlot, this.date, this.flag, this.dHelper, this.pHelper, this.dHelperFull,
    this.createdAt, this.apptId, this.calDHelper, this.calPHelper
  });

  Map<String, dynamic> toMap() {
    return {
      'pId': pId,
      'dId': dId,
      'date': date,
      'timeSlot': timeSlot,
      'flag' : flag,
      'dHelper': dHelper,
      'pHelper': pHelper,
      'dHelperFull': dHelperFull,
      'createdAt' : createdAt,
      'apptId': this.apptId,
      'calDHelper': this.calDHelper,
      'calPHelper' : this.calPHelper
    };
  }

  static Appointment fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }
    return Appointment(
        pId: map['pId'],
        dId: map['dId'],
        date: map['date'],
        timeSlot: map['timeSlot'],
        flag: map['flag'],
        dHelper: map['dHelper'],
        pHelper: map['pHelper'],
        dHelperFull: map['dHelperFull'],
        createdAt: map['createdAt'],
        apptId: map['apptId'],
        calDHelper: map['calDHelper'],
        calPHelper: map['calPHelper'],
    );
  }

  /*Appointment.fromJson(Map<dynamic, dynamic> json){
    pId = json['pId'];
    dId = json['dId'];
    date = json['date'];
    timeSlot = json['timeSlot'];
    flag = json['flag'];
    dHelper = json['dHelper'];
    pHelper = json['pHelper'];
  }*/
}
