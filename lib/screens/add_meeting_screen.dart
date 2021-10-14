import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/screens/select_meeting_attendee_screen.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes.dart';

class AddMeetingScreen extends StatefulWidget {
  @override
  State<AddMeetingScreen> createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Contact> addedContacts = [];

  @override
  Widget build(BuildContext context) {
    final inputStyle = TextStyle(color: Colors.white);

    return AuthenticatedScaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("Add Meeting"),
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
                          child: TextField(
                            style: inputStyle,
                            decoration: InputDecoration(
                              labelText: "Date",
                              hintText: "dd/mm/yyyy",
                            ),
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                firstDate: DateTime(2015),
                                lastDate: DateTime(
                                  2099,
                                  8,
                                ),
                                initialDate: DateTime.now(),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            style: inputStyle,
                            decoration: InputDecoration(
                              labelText: "Time",
                              hintText: "hh:mm",
                            ),
                            onTap: () async {
                              await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    maxLines: 3,
                    style: inputStyle,
                    decoration: InputDecoration(labelText: "Notes"),
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
                        if (_formKey.currentState!.validate()) {}
                      },
                      style: ButtonThemes.elevatedButtonThemeLight(
                        color: const Color(0xFFF9AA33),
                      ),
                      child: Text(
                        "SAVE CONTACT",
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
            (e) => _buildChip(e.fullName, Color(0xFFff6666)),
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

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }
}
