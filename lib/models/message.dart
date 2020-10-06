import 'package:intl/intl.dart';

class Message{
  String dId;
  String dHelper;
  String date;
  String msg;

  Message({this.dId, this.dHelper, this.date, this.msg});

  Map<String, dynamic> toMap() {
    return {
      'dId': dId,
      'dHelper': dHelper,
      'date': date,
      'msg': msg
    };
  }

  static Message fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }
    return Message(
        dId: map['dId'],
        dHelper: map['dHelper'],
        date: map['date'],
        msg: map['msg']
    );
  }
}