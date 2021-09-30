import 'package:dot_mobile/themes.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:dot_mobile/models/calendar.dart';
import 'add_calendar.dart';
import 'package:get/get.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(() => AddCalendarScreen());
          },
          label: Text(
            "Add Event",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFFF9AA33),
        ),
        body: Container(
          child: SfCalendar(
            view: CalendarView.schedule,
            firstDayOfWeek: 1,
            dataSource: MeetingDataSource(getAppointments()),
          ),
        ));
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'conference',
      color: Colors.blue));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
