import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

class DotModel {
  static const contactDbName = "contact";

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

  Query<Contact> get allContactsQuery {
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
        )
        .where('dotProfile',
            isNotEqualTo: FirebaseAuth.instance.currentUser!.email!)
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.email!);
  }

  Future<Contact> get myself async {
    final snapshot = await FirebaseFirestore.instance
        .collection(contactDbName)
        .where(
          'dotProfile',
          isEqualTo: FirebaseAuth.instance.currentUser!.email!,
        )
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
    ).get();
    return snapshot.docs.first.data();
  }

  Future<DocumentReference<Contact>> addContact(Contact contact) {
    return contactDbRef.add(contact);
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
    this.dotProfile="",
    required this.avatar,
  });

  String get fullName {
    return firstName + " " + lastName;
  }

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
