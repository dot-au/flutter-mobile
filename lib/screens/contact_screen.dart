import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticatedScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          "Add Contact",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFF9AA33),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            SearchField(),
          ]),
        ),
      ),
      active: 3,
    );
  }
}

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(100000)),
      borderSide: BorderSide(
        width: 2,
        color: Colors.white,
      ),
    );
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.search_outlined,
          color: Colors.black,
        ),
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        hintText: "Search a contact....",
        focusColor: Colors.black,
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}
