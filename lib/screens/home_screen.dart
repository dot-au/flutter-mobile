import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          Text("Welcome " + getName(),
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              )),
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
