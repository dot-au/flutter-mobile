import 'package:dot_mobile/screens/Calendar.dart';
import 'package:dot_mobile/screens/Events.dart';
import 'package:dot_mobile/screens/Message.dart';
import 'package:dot_mobile/screens/Setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contact_screen.dart';

class PersonalProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo-white.png',
                  width: 150,
                  height: 300,
                ),
                Text(
                  "Welcome <username>",
                  style: Get.textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () async {
                  await Get.to(() => Calendar());
                },
                icon: Image.asset(
                  'assets/calendar.png',
                ),
                iconSize: 50,
              ),
              IconButton(
                onPressed: () async {
                  await Get.to(() => Message());
                },
                icon: Image.asset(
                  'assets/message.png',
                ),
                iconSize: 50,
              ),
              IconButton(
                onPressed: () async {
                  await Get.to(() => Events());
                },
                icon: Image.asset(
                  'assets/events.png',
                ),
                iconSize: 50,
              ),
              IconButton(
                onPressed: () async {
                  await Get.to(() => ContactScreen());
                },
                icon: Image.asset(
                  'assets/contacts.png',
                ),
                iconSize: 50,
              ),
              IconButton(
                onPressed: () async {
                  await Get.to(() => Setting());
                },
                icon: Image.asset(
                  'assets/setting.png',
                ),
                iconSize: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
