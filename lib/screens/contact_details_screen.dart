import 'package:dot_mobile/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'add_contact_screen.dart';

class ContactDetailsScreen extends StatelessWidget {
  final Contact contact;

  const ContactDetailsScreen({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                Get.back();
                await Get.to(() => AddContactScreen(contact: contact));
              },
            ),
          ]),
          Column(
            children: [
              Container(
                width: 72,
                height: 72,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    contact.avatar,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  bottom: 18.0,
                ),
                child: Text(
                  contact.fullName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _ContactDetailInfo(contact: contact),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactDetailInfo extends StatelessWidget {
  final Contact contact;

  const _ContactDetailInfo({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _ContactDetailInfoRow(
        title: "Phone Number",
        content: contact.phone,
      ),
      _ContactDetailInfoRow(
        title: "Email",
        content: contact.email,
        onPressed: () {},
      ),
      _ContactDetailInfoRow(
        title: "Address",
        content: contact.address,
        onPressed: () {},
      ),
      _ContactDetailInfoRow(
        title: "Company",
        content: contact.company,
        onPressed: () {},
      ),
      _ContactDetailInfoRow(
        title: "Notes",
        content: contact.notes,
        onPressed: () {},
      ),
    ]);
  }
}

class _ContactDetailInfoRow extends StatelessWidget {
  static const notProvidedText = "N/A";

  final String title;
  final String? content;
  final VoidCallback? onPressed;

  const _ContactDetailInfoRow({
    Key? key,
    required this.title,
    this.content,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 2.3,
      fontSize: 16,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 12.0),
          child: Row(children: [
            Padding(
              padding: EdgeInsets.only(right: 2.0),
              child: Container(
                width: 120,
                child: Text(title, style: textStyle),
              ),
            ),
            Text(":", style: textStyle),
          ]),
        ),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft),
            onPressed: isContentNotProvided()
                ? null
                : () async {
                    await Clipboard.setData(ClipboardData(text: content));
                    Get.snackbar(
                      "Clipboard copied!",
                      title + " has been copied to the clipboard",
                    );
                  },
            child: Text(isContentNotProvided() ? notProvidedText : content!),
          ),
        ),
      ],
    );
  }

  bool isContentNotProvided() {
    return content == null || content!.trim().isEmpty;
  }
}
