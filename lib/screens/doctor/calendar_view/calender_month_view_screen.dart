import 'package:doctors_app/screens/doctor/appointment_list/doc_appointment_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 60, bottom: 20),
          child: SfCalendar(
            view: CalendarView.month,
            onTap: (CalendarTapDetails calendarTapDetails){
              print('calendar onTap date: '+calendarTapDetails.date.toString());
              pushNewScreen(
                context,
                screen: DocAppointmentListScreen(user: widget.user, selectedDate: calendarTapDetails.date,),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
    ));
  }
}
