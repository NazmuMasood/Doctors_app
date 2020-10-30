import 'package:doctors_app/models/appointment.dart' as mAppointment;
import 'package:doctors_app/screens/doctor/appointment_list/doc_appointment_list_screen.dart';
import 'package:doctors_app/services/helper_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MonthViewScreen extends StatefulWidget {
  const MonthViewScreen({Key key, @required this.user}) : super(key: key);
  final User user;

  @override
  _MonthViewScreenState createState() => _MonthViewScreenState();
}

class _MonthViewScreenState extends State<MonthViewScreen> {
  List<Meeting> meetings;
  //List<mAppointment.Appointment> appts;
  Map<String, int> apptMap;
  bool apptDataAvailable = false;
  final DatabaseReference appointmentsRef = FirebaseDatabase.instance.reference().child("appointments");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 60, bottom: 20),
          child: SfCalendar(
            view: CalendarView.month,
            appointmentTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial'),
            todayTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial'),
            dataSource: apptDataAvailable && apptMap.length>0 ? MeetingDataSource(_getDataSource()) : null,
            monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                dayFormat: 'EEE',
            ),
            onTap: (CalendarTapDetails calendarTapDetails){
              print('calendar onTap date: '+calendarTapDetails.date.toString());
              pushNewScreen(context,
                screen: DocAppointmentListScreen(user: widget.user, selectedDate: calendarTapDetails.date,),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
    ));
  }

  List<Meeting> _getDataSource() {
    meetings = <Meeting>[];
    apptMap.forEach((key, value) {
      final DateTime today = DateTime.parse(key.toString().split('_')[0]);
      String timeSlot = key.toString().split('_')[1];
      final DateTime startTime = DateTime(today.year, today.month, today.day,
          timeSlot=='0'? 9 : timeSlot=='1'? 13 : timeSlot=='2'? 17 : 0, 0, 0);
      final DateTime endTime = startTime.add(const Duration(hours: 3));
      meetings.add(Meeting(value.toString(), startTime, endTime,
                    timeSlot=='0'? HelperClass.colorFromHex('#1E90FF')
                  : timeSlot=='1'? HelperClass.colorFromHex('#ff9000')
                  : timeSlot=='2'? HelperClass.colorFromHex('#670067')
                  : const Color(0xFF0F8644),
              false),//default green(int) : 0xFF0F8644
      );
    });//forEach apptMap

    return meetings;
  }

  Future<void> _fetchAppointments() async {
    //appts = [];
    apptMap = new Map();
    DateTime today = DateTime.now();
    String calDHelper = widget.user.email + '_' + today.toString().split(' ')[0].substring(0, 7);
    try {
      await appointmentsRef.orderByChild('calDHelper').equalTo(calDHelper).once().then((DataSnapshot snap) {
        Map values = snap.value;
        //print('calendar fetchAppts: values- ' + values.toString());
        if (values == null) {
          HelperClass.showToast('No appointments');
          return;
        }
        values.forEach((key, value) {
          String apptDate = value['date'];
          String timeSlot = value['timeSlot'];
          //String dateOfMonth = apptDate.substring(apptDate.length-2, apptDate.length);
          addToMap(dateAndTimeSlot: apptDate + "_" + timeSlot);
        });
        print('apptMap: ' + apptMap.toString());
        setState(() {apptDataAvailable = true;});
      });
    }catch(e){  print(e.message); HelperClass.showToast('Appointments fetching error');}

  }

  void addToMap({String dateAndTimeSlot}) {
    if (apptMap.containsKey(dateAndTimeSlot)) {
      apptMap.update(dateAndTimeSlot, (int) => apptMap[dateAndTimeSlot]+1);
      return;
    }
    apptMap[dateAndTimeSlot] = 1;
  }

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }


}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
