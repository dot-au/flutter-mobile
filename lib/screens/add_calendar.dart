import 'package:dot_mobile/models/calendar.dart';
import 'package:dot_mobile/themes.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddCalendarScreen extends StatefulWidget {
  final Calendar? calendar;

  const AddCalendarScreen({Key? key, this.calendar}) : super(key: key);

  @override
  State<AddCalendarScreen> createState() => _AddCalendarScreenState();
}

class _AddCalendarScreenState extends State<AddCalendarScreen> {
  final hostController = TextEditingController();
  final guestController = TextEditingController();
  final dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final calendar = widget.calendar;
    if (calendar != null) {
      hostController.text = calendar.Host;
      guestController.text = calendar.Guest;
      dateController.text = calendar.Date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = TextStyle(color: Colors.white);

    return AuthenticatedScaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("New Event"),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 8.0,
                          top: 16.0,
                          bottom: 16.0,
                        ),
                        child: TextFormField(
                          style: inputStyle,
                          decoration: InputDecoration(labelText: "Host Name"),
                          controller: hostController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Host name is required!";
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 8.0,
                          top: 16.0,
                          bottom: 16.0,
                        ),
                        child: TextFormField(
                          style: inputStyle,
                          decoration:
                              InputDecoration(labelText: "Guest Name List"),
                          controller: guestController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Guest name is required!";
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final calendar = Calendar(
                            uid: widget.calendar == null
                                ? null
                                : widget.calendar!.uid,
                            user: FirebaseAuth.instance.currentUser!.email!,
                            Host: hostController.text,
                            Guest: guestController.text,
                            Date: dateController.text,
                          );

                          if (calendar.uid == null) {
                            await DotModel().addCalendar(calendar);
                          } else {
                            await DotModel().updateCalendar(calendar);
                          }

                          Get.back();
                        }
                      },
                      style: ButtonThemes.elevatedButtonThemeLight(
                        color: const Color(0xFFF9AA33),
                      ),
                      child: Text(
                        "SAVE EVENT",
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
}
