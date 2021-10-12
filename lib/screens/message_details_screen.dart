import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_mobile/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:dot_mobile/models/models.dart' as models;

// For the testing purposes, you should probably use https://pub.dev/packages/uuid
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class MessageDetailsScreen extends StatefulWidget {
  final Contact user;

  const MessageDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _MessageDetailsScreenState createState() => _MessageDetailsScreenState();
}

class _MessageDetailsScreenState extends State<MessageDetailsScreen> {
  Future<void> _handleSendPressed(types.PartialText message) async {
    await DotModel().addMessage(
      models.Message(
        author: FirebaseAuth.instance.currentUser!.email!,
        to: [FirebaseAuth.instance.currentUser!.email!, widget.user.email],
        content: message.text,
        created: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Column(children: [
          Text(widget.user.fullName),
        ]),
      ),
      body: SafeArea(
        bottom: false,
        child: StreamBuilder<QuerySnapshot<models.Message>>(
            stream: DotModel().getMessages().snapshots(),
            builder: (context, snapshot) {
              List<types.TextMessage> messages = [];
              if (snapshot.hasData) {
                final docs = snapshot.data!.docs;
                docs.removeWhere((element) =>
                    !element.data().to.contains(widget.user.email));
                docs.sort(
                    (a, b) => -a.data().created.compareTo(b.data().created));
                messages = docs
                    .map(
                      (e) => types.TextMessage(
                          author: types.User(id: e.data().author),
                          id: e.data().uid!,
                          text: e.data().content,
                          createdAt: e.data().created.millisecondsSinceEpoch),
                    )
                    .toList();
              }
              return Chat(
                messages: messages,
                onSendPressed: _handleSendPressed,
                user: types.User(id: FirebaseAuth.instance.currentUser!.email!),
                theme: DarkChatTheme(
                  backgroundColor:
                      Get.theme.scaffoldBackgroundColor.withOpacity(1),
                  inputBackgroundColor: Get.theme.primaryColor,
                ),
              );
            }),
      ),
    );
  }
}
