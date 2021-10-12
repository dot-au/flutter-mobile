import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

class DotModel {
  static const contactDbName = "contact";
  static const messageDbName = "message";

  CollectionReference<Contact> get contactDbRef {
    return FirebaseFirestore.instance
        .collection(contactDbName)
        .withConverter<Contact>(
      fromFirestore: (snapshots, _) {
        final data = snapshots.data()!;
        data.putIfAbsent('uid', () => snapshots.id);
        return Contact.fromJson(data);
      },
      toFirestore: (contact, _) {
        final data = contact.toJson();
        data.remove('uid');
        return data;
      },
    );
  }

  CollectionReference<Message> get messageRef {
    return FirebaseFirestore.instance
        .collection(messageDbName)
        .withConverter<Message>(
      fromFirestore: (snapshots, _) {
        final data = snapshots.data()!;
        data.putIfAbsent('uid', () => snapshots.id);
        return Message.fromJson(data);
      },
      toFirestore: (message, _) {
        final data = message.toJson();
        data.remove('uid');
        return data;
      },
    );
  }

  Query<Message> getMessages() {
    return messageRef.where('to',
        arrayContains: FirebaseAuth.instance.currentUser!.email!);
  }

  Query<Map<String, dynamic>> isUserOnDot(String email) {
    return FirebaseFirestore.instance
        .collection(contactDbName)
        .where(
          'dotProfile',
          isEqualTo: email,
        )
        .where(
          'user',
          isEqualTo: email,
        );
  }

  Query<Contact> getContactByEmail(String email) {
    return contactDbRef
        .where(
          'email',
          isEqualTo: email,
        )
        .where(
          'user',
          isEqualTo: FirebaseAuth.instance.currentUser!.email!,
        );
  }

  Query<Contact> get allContactsQuery {
    return contactDbRef
        .where('dotProfile',
            isNotEqualTo: FirebaseAuth.instance.currentUser!.email!)
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.email!);
  }

  Future<Contact> get myself async {
    final snapshot = await contactDbRef
        .where(
          'dotProfile',
          isEqualTo: FirebaseAuth.instance.currentUser!.email!,
        )
        .get();
    return snapshot.docs.first.data();
  }

  Future<DocumentReference<Contact>> addContact(Contact contact) {
    return contactDbRef.add(contact);
  }

  Future<DocumentReference<Message>> addMessage(Message message) {
    return messageRef.add(message);
  }

  Future updateContact(Contact contact) async {
    await contactDbRef.doc(contact.uid!).set(contact);
  }
}

@JsonSerializable()
class Contact {
  final String user;
  final String firstName;
  final String lastName;
  final String address;
  final String email;
  final String phone;
  final String company;
  final String notes;
  final String avatar;
  final String? dotProfile;
  final String? uid;

  Contact({
    this.uid,
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.email,
    required this.phone,
    required this.company,
    required this.notes,
    this.dotProfile = "",
    required this.avatar,
  });

  String get fullName {
    return firstName + " " + lastName;
  }

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

@JsonSerializable()
class Message {
  final String author;
  final String content;
  final DateTime created;
  final List<String> to;
  final String? uid;

  Message({
    this.uid,
    required this.content,
    required this.created,
    required this.author,
    required this.to,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
