import 'package:dot_mobile/themes.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inputStyle = TextStyle(color: Colors.white);

    return AuthenticatedScaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("New Contact"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: 8.0, top: 16.0, bottom: 16.0),
                      child: TextField(
                        style: inputStyle,
                        decoration: InputDecoration(labelText: "First name"),
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
                      child: TextField(
                        style: inputStyle,
                        decoration: InputDecoration(labelText: "Last name"),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  style: inputStyle,
                  decoration: InputDecoration(
                    labelText: "Address",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  style: inputStyle,
                  decoration: InputDecoration(labelText: "Email"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  style: inputStyle,
                  decoration: InputDecoration(labelText: "Phone"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  style: inputStyle,
                  decoration: InputDecoration(labelText: "Company"),
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
                    onPressed: () {},
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
      active: 3,
    );
  }
}
