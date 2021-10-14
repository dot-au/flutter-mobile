import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../themes.dart';
import 'add_meeting_screen.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticatedScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddMeetingScreen());
        },
        label: Text(
          "Add Meeting",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFF9AA33),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: TableEventsExample(),
        ),
      ),
      active: 0,
    );
  }
}

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  var meetings = <Meeting>[];

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    DotModel().getMeetings().snapshots().listen((event) {
      setState(() {
        this.meetings = event.docs.map((e) => e.data()).toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Meeting> _getEventsForDay(DateTime day) {
    // print(meetings);
    // Implementation example
    final todayMeetings = <Meeting>[];
    for (final meeting in meetings) {
      // print(meeting.date);
      if (day.month == meeting.date.month &&
          day.year == meeting.date.year &&
          day.day == meeting.date.day) {
        todayMeetings.add(meeting);
      }
    }
    // print(todayMeetings);
    return todayMeetings;
    // return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      // _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayMeetings = _getEventsForDay(_focusedDay);
    todayMeetings.sort((a, b) => a.date.compareTo(b.date));
    return Column(
      children: [
        Container(
          height: 420,
          child: Card(
            color: Colors.white,
            elevation: 14.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: TableCalendar<Meeting>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                sixWeekMonthsEnforced: true,
                availableCalendarFormats: {CalendarFormat.month: 'Month'},
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  selectedDecoration: BoxDecoration(
                    color: ColorThemes.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: ColorThemes.secondaryColor.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: Get.theme.textTheme.headline6!.copyWith(
                    fontSize: 16.0,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Get.theme.scaffoldBackgroundColor,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Get.theme.scaffoldBackgroundColor,
                  ),
                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: null,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        if (todayMeetings.isEmpty)
          Container(
            width: 200,
            height: 200,
            child: EmptyWidget(
              hideBackgroundAnimation: true,
              image: null,
              packageImage: PackageImage.Image_2,
              title: 'No meetings',
              titleTextStyle: TextStyle(
                fontSize: 22,
                color: Color(0xff9da9c7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Column(
          children: todayMeetings.map((e) => MeetingEvent(meeting: e)).toList(),
        ),
      ],
    );
  }
}

class MeetingEvent extends StatefulWidget {
  final Meeting meeting;

  const MeetingEvent({Key? key, required this.meeting}) : super(key: key);

  @override
  State<MeetingEvent> createState() => _MeetingEventState();
}

class _MeetingEventState extends State<MeetingEvent> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();

    DotModel()
        .getContactsByEmailList(widget.meeting.attendees)
        .snapshots()
        .listen((event) {
      setState(() {
        this.contacts = event.docs.map((e) => e.data()).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Card(
        color: const Color(0xFF4A6572),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          onTap: () async {
            await Get.to(
              () => AddMeetingScreen(
                meeting: widget.meeting,
                contacts: contacts,
              ),
            );
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat("dd/MM/yyyy HH:mm").format(widget.meeting.date),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              _buildChips(contacts),
              if (widget.meeting.notes.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Notes: " + widget.meeting.notes,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChips(List<Contact> contacts) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 12.0,
        runSpacing: 3.0,
        children: <Widget>[
          ...contacts.map(
            _buildChip,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(Contact contact) {
    return Chip(
      elevation: 1.0,
      padding: EdgeInsets.all(2.0),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(contact.fullName),
        ],
      ),
    );
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
