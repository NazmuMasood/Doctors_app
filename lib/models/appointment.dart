import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class Appointment {
  String patientId;
  String doctorId;
  String date;
  String time;
  String flag;
  String dHelper;
  String pHelper;

  Appointment({this.patientId, this.doctorId, this.time, this.date, this.flag, this.dHelper, this.pHelper});

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'date': date,
      'time': time,
      'flag' : flag,
      'dHelper': dHelper,
      'pHelper': pHelper
    };
  }

  static Appointment fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }
    return Appointment(
        patientId: map['patientId'],
        doctorId: map['doctorId'],
        date: map['date'],
        time: map['time'],
        flag: map['flag'],
        dHelper: map['dHelper'],
        pHelper: map['pHelper']
    );
  }

  Appointment.fromJson(Map<dynamic, dynamic> json){
    patientId = json['patientId'];
    doctorId = json['doctorId'];
    date = json['date'];
    time = json['time'];
    flag = json['flag'];
    dHelper = json['dHelper'];
    pHelper = json['pHelper'];
  }
}
