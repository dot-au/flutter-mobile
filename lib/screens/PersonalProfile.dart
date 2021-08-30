import 'package:dot_mobile/screens/Contact_screens/Contact.dart';
import 'package:dot_mobile/screens/Message.dart';
import 'package:dot_mobile/screens/Events.dart';
import 'package:dot_mobile/screens/Setting.dart';
import 'package:dot_mobile/screens/Calendar.dart';
import 'package:dot_mobile/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  await Get.to(() => Contact());
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

  Widget _buildButton({
    required Widget child,
    ButtonStyle? style,
    required VoidCallback onPressed,
  }) {
    final bottomSafeArea = MediaQuery.of(Get.context!).padding.bottom;
    // final paddingBottom = max<double>(
    //   0,
    //   16 - bottomSafeArea,
    // );

    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 16, 12, 0
            //paddingBottom,
            ),
        height: 64,
        child: OutlinedButton(
          onPressed: onPressed,
          child: child,
          style: style,
        ),
      ),
    );
  }
}
