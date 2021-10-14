import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/screens/select_meeting_attendee_screen.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../themes.dart';

class AddMeetingScreen extends StatefulWidget {
  final Meeting? meeting;
  final List<Contact> contacts;

  const AddMeetingScreen({Key? key, this.meeting, this.contacts = const []})
      : super(key: key);

  @override
  State<AddMeetingScreen> createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Contact> addedContacts = [];

  final dateInputController = TextEditingController(
    text: DateFormat("dd/MM/yyyy").format(DateTime.now()),
  );
  final timeInputController = TextEditingController(
    text: DateFormat("HH:mm").format(DateTime.now()),
  );
  var dateTime = DateTime.now();
  final notesInputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.meeting != null) {
      dateInputController.text =
          DateFormat("dd/MM/yyyy").format(widget.meeting!.date);
      timeInputController.text =
          DateFormat("HH:mm").format(widget.meeting!.date);
      notesInputController.text = widget.meeting!.notes;
      if (widget.contacts.length >= 1) {
        addedContacts =
            widget.contacts.getRange(1, widget.contacts.length).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = TextStyle(color: Colors.white);

    return AuthenticatedScaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(widget.meeting != null ? "Edit Meeting" : "Add Meeting"),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: TextFormField(
                            style: inputStyle,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter a date";
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Date",
                              hintText: "dd/mm/yyyy",
                            ),
                            controller: dateInputController,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2015),
                                lastDate: DateTime(
                                  2099,
                                  8,
                                ),
                                initialDate: DateTime.now(),
                              );

                              if (date != null) {
                                setState(() {
                                  dateTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    dateTime.hour,
                                    dateTime.minute,
                                  );
                                });
                                dateInputController.text =
                                    DateFormat('dd/MM/yyyy').format(date);
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: timeInputController,
                            style: inputStyle,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter a time";
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Time",
                              hintText: "hh:mm",
                            ),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (time != null) {
                                setState(() {
                                  dateTime = DateTime(
                                    dateTime.year,
                                    dateTime.month,
                                    dateTime.day,
                                    time.hour,
                                    time.minute,
                                  );
                                });

                                timeInputController.text =
                                    DateFormat('HH:mm').format(dateTime);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextFormField(
                    maxLines: 3,
                    style: inputStyle,
                    decoration: InputDecoration(labelText: "Notes"),
                    controller: notesInputController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: _buildChips(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final meeting = new Meeting(
                            createdBy: widget.meeting != null
                                ? widget.meeting!.createdBy
                                : FirebaseAuth.instance.currentUser!.email!,
                            notes: notesInputController.text,
                            attendees: [
                              FirebaseAuth.instance.currentUser!.email!,
                              ...addedContacts.map((e) => e.email).toList()
                            ],
                            date: dateTime,
                            uid: widget.meeting != null
                                ? widget.meeting!.uid
                                : null,
                          );

                          if (meeting.uid == null) {
                            await DotModel().addMeeting(meeting);
                          } else {
                            await DotModel().updateMeeting(meeting);
                          }

                          Get.back();
                        }
                      },
                      style: ButtonThemes.elevatedButtonThemeLight(
                        color: const Color(0xFFF9AA33),
                      ),
                      child: Text(
                        "SAVE MEETING",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      active: 3,
    );
  }

  Widget _buildChips() {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 12.0,
        runSpacing: 3.0,
        children: <Widget>[
          ...addedContacts.map(
            _buildChip,
          ),
          ActionChip(
            elevation: 1.0,
            padding: EdgeInsets.all(2.0),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.add),
                ),
                Text('Add an attendee'),
              ],
            ),
            onPressed: () {
              Get.to(
                () => SelectMeetingAttendeeScreen(
                  onSelectAttendee: (attendee) async {
                    setState(() {
                      addedContacts = [...addedContacts, attendee];
                    });
                  },
                  addedContacts: addedContacts,
                ),
              );
            },
            backgroundColor: ColorThemes.secondaryColor,
            pressElevation: 16.0,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(Contact contact) {
    return ActionChip(
      elevation: 1.0,
      padding: EdgeInsets.all(2.0),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Icon(Icons.close),
          ),
          Text(contact.fullName),
        ],
      ),
      onPressed: () {
        setState(() {
          addedContacts = addedContacts.where((e) => e != contact).toList();
        });
      },
      pressElevation: 16.0,
    );
  }
}
