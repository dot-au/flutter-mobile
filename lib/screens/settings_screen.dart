import 'package:dot_mobile/main.dart';
import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contact_details_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticatedScaffold(
      active: 4,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    ListTile(
                      title: Text(
                        FirebaseAuth.instance.currentUser!.email!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "My Profile",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      leading: Icon(Icons.info),
                      onTap: () async {
                        final contact = await DotModel().myself;
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Get.theme.scaffoldBackgroundColor,
                          builder: (BuildContext context) {
                            return ContactDetailsScreen(contact: contact);
                          },
                          context: context,
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Log Out",
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                      leading: Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        await Get.offAll(
                          () => StarterPage(),
                          transition: Transition.fadeIn,
                        );
                      },
                    ),
                  ],
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
