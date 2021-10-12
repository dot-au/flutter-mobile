import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_mobile/models/models.dart';
import 'package:dot_mobile/widgets/authenticated_scaffold.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'contact_screen.dart';
import 'message_details_screen.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticatedScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchField(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: StreamBuilder(
                    stream: DotModel().getMessages().snapshots(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Message>> snapshot,
                    ) {
                      final Map<String, Map> chatrooms = {};
                      if (snapshot.hasData) {
                        final docs = snapshot.data!.docs;

                        // get all the chat rooms
                        docs.forEach((e) {
                          final key = e.data().to;
                          key.sort();
                          chatrooms.putIfAbsent(key.toString(),
                              () => {'people': key, 'chats': <Map>[]});

                          chatrooms[key.toString()]!['chats'].add({
                            'content': e.data().content,
                            'created': e.data().created,
                          });
                        });

                        chatrooms.keys.forEach((k) =>
                            (chatrooms[k]!['chats'] as List).sort((a, b) =>
                                -a['created'].compareTo(b['created'])));

                        if (chatrooms.isEmpty) {
                          return Container(
                            margin: EdgeInsets.only(top: 64),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1000)),
                              color: Colors.white,
                            ),
                            width: 240,
                            height: 240,
                            child: EmptyWidget(
                              hideBackgroundAnimation: true,
                              image: null,
                              packageImage: PackageImage.Image_2,
                              title: 'No contacts',
                              titleTextStyle: TextStyle(
                                fontSize: 22,
                                color: Color(0xff9da9c7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }

                        final sortedChatroomKeys = chatrooms.keys.toList();
                        sortedChatroomKeys.sort((a, b) => chatrooms[a]!['chats']
                                [0]['created']
                            .compareTo(chatrooms[b]!['chats'][0]['created']));

                        return Column(
                          children: sortedChatroomKeys
                              .map(
                                (key) => ChatRoomTile(chatroom: chatrooms[key]),
                              )
                              .toList(),
                        );
                      }
                      return Container();
                    }),
              ),
            ],
          ),
        ),
      ),
      active: 1,
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final dynamic chatroom;

  const ChatRoomTile({Key? key, this.chatroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(_otherContact());
    return FutureBuilder<QuerySnapshot<Contact>>(
        future: DotModel().getContactByEmail(_otherContact()).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final contact = snapshot.data!.docs[0].data();
            return ListTile(
                onTap: () {
                  Get.to(
                    () => MessageDetailsScreen(
                      user: contact,
                    ),
                  );
                },
                title: Text(
                  contact.fullName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  chatroom['chats'][0]['content'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  timeago.format(chatroom['chats'][0]['created']),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    contact.avatar,
                  ),
                ));
          }
          return Container();
        });
  }

  String _otherContact() {
    final people = chatroom['people'];
    for (final person in people) {
      if (person != FirebaseAuth.instance.currentUser!.email) {
        return person;
      }
    }

    return people[0];
  }
}
