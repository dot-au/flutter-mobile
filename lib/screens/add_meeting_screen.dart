import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes.dart';

class AddMeetingScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
                  child: TextField(
                    style: inputStyle,
                    decoration: InputDecoration(labelText: "Email"),
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(
                          2099,
                          8,
                        ),
                        initialDate: DateTime(2015, 8),
                      );
                    },
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
}
