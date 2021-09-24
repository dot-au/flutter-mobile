import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/themes.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:uuid/uuid.dart';

class AddContactScreen extends StatefulWidget {
  final Contact? contact;

  const AddContactScreen({Key? key, this.contact}) : super(key: key);

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final companyController = TextEditingController();
  final notesController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final contact = widget.contact;
    if (contact != null) {
      firstNameController.text = contact.firstName;
      lastNameController.text = contact.lastName;
      emailController.text = contact.email;
      addressController.text = contact.address;
      companyController.text = contact.company;
      notesController.text = contact.notes;
      phoneController.text = contact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = TextStyle(color: Colors.white);

    return AuthenticatedScaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("New Contact"),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "First name is required!";
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
                          decoration: InputDecoration(labelText: "Last name"),
                          controller: lastNameController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Last name is required!";
                            }
                          },
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
                    controller: addressController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    style: inputStyle,
                    decoration: InputDecoration(labelText: "Email"),
                    controller: emailController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    style: inputStyle,
                    decoration: InputDecoration(labelText: "Phone"),
                    controller: phoneController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    style: inputStyle,
                    decoration: InputDecoration(labelText: "Company"),
                    controller: companyController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    maxLines: 3,
                    style: inputStyle,
                    decoration: InputDecoration(labelText: "Notes"),
                    controller: notesController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final contact = Contact(
                            uid: widget.contact == null
                                ? null
                                : widget.contact!.uid,
                            user: FirebaseAuth.instance.currentUser!.email!,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                            notes: notesController.text,
                            avatar: widget.contact == null
                                ? Gravatar("${Uuid().v1()}@example.com")
                                    .imageUrl(
                                    size: 200,
                                    defaultImage: GravatarImage.retro,
                                    rating: GravatarRating.pg,
                                    fileExtension: true,
                                  )
                                : widget.contact!.avatar,
                            company: companyController.text,
                          );

                          if (contact.uid == null) {
                            await DotModel().addContact(contact);
                          } else {
                            await DotModel().updateContact(contact);
                          }

                          Get.back();
                        }
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
