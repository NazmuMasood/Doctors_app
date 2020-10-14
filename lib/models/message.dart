import 'package:intl/intl.dart';

class Message{
  String dId;
  String dHelperFull;
  String date;
  String msg;

  Message({this.dId, this.dHelperFull, this.date, this.msg});

  Map<String, dynamic> toMap() {
    return {
      'dId': dId,
      'dHelperFull': dHelperFull,
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
        dHelperFull: map['dHelperFull'],
        date: map['date'],
        msg: map['msg']
    );
  }
}