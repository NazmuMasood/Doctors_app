class Appointment {
  String patientId;
  String doctorId;
  String date;
  String time;
  String flag;

  Appointment({this.patientId, this.doctorId, this.time, this.date, this.flag});

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'date': date,
      'time': time,
      'flag' : flag
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
        flag: map['flag']);
  }

  Appointment.fromJson(Map<dynamic, dynamic> json){
    patientId = json['patientId'];
    doctorId = json['doctorId'];
    date = json['date'];
    time = json['time'];
    flag = json['flag'];
  }
}
