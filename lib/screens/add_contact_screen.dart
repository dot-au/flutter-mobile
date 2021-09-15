import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/themes.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:uuid/uuid.dart';

class AddContactScreen extends StatefulWidget {
  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final firstNameController = TextEditingController.fromValue(
    TextEditingValue(text: "Something"),
  );

  final lastNameController = TextEditingController.fromValue(
    TextEditingValue(text: "Something1"),
  );

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
                      padding: EdgeInsets.only(
                        right: 8.0,
                        top: 16.0,
                        bottom: 16.0,
                      ),
                      child: TextFormField(
                        style: inputStyle,
                        decoration: InputDecoration(labelText: "First name"),
                        controller: firstNameController,
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
                        decoration: InputDecoration(labelText: "Last name"),
                        controller: lastNameController,
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
                    onPressed: () async {
                      await DotModel().addContact(Contact(
                        user: FirebaseAuth.instance.currentUser!.email!,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        avatar: Gravatar("${Uuid().v1()}@example.com").imageUrl(
                          size: 200,
                          defaultImage: GravatarImage.retro,
                          rating: GravatarRating.pg,
                          fileExtension: true,
                        ),
                      ));
                      Get.back();
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
      active: 3,
    );
  }
}
