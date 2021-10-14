import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'calendar_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticatedScaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(
              top: 48.0,
              bottom: 24.0,
            ),
            child: Center(
                child: Image.asset(
              "assets/logo-white.png",
              width: 192,
            )),
          ),
          FutureBuilder<Contact>(
            future: DotModel().myself,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  "Welcome ${snapshot.data!.fullName}",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                );
              }

              return Container();
            },
          ),
          Divider(
            height: 60,
            thickness: 3,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Today's Meetings",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot<Meeting>>(
                builder: (BuildContext context, snapshot) {
                  final meetings = <Meeting>[];
                  if (snapshot.hasData) {
                    snapshot.data!.docs.forEach((element) {
                      final date = element.data().date;
                      final today = DateTime.now();
                      if (date.year == today.year &&
                          date.month == today.month &&
                          date.day == today.day) {
                        meetings.add(element.data());
                      }
                    });

                    if (meetings.isEmpty) {
                      return Container(
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
                      );
                    }
                  }
                  meetings.sort((a, b) => a.date.compareTo(b.date));
                  return Column(
                    children: meetings
                        .map(
                          (e) => MeetingEvent(
                            meeting: e,
                          ),
                        )
                        .toList(),
                  );
                },
                stream: DotModel().getMeetings().snapshots(),
              ),
            ]),
          ),
        ]),
      ),
      active: 2,
    );
  }

  String getName() {
    var name = FirebaseAuth.instance.currentUser!.email!;

    var displayName;
    if (displayName != null) {
      name = displayName;
    }

    return name;
  }
}
