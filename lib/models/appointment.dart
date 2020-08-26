class Appointment {
  String patientId;
  String doctorId;
  String date;
  String time;

  Appointment({this.patientId, this.doctorId, this.time, this.date});

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'date': date,
      'time': time
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
        time: map['time']);
  }

  Appointment.fromJson(Map<dynamic, dynamic> json){
    patientId = json['patientId'];
    doctorId = json['doctorId'];
    date = json['date'];
    time = json['time'];
  }
}
