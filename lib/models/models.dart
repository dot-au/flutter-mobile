import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'models.g.dart';

class DotModel {
  static const contactDbName = "contact";

  CollectionReference<Contact> get contactDbRef {
    return FirebaseFirestore.instance
        .collection(contactDbName)
        .withConverter<Contact>(
          fromFirestore: (snapshots, _) => Contact.fromJson(snapshots.data()!),
          toFirestore: (contact, _) => contact.toJson(),
        );
  }

  Future<DocumentReference<Contact>> addContact(Contact contact) {
    return contactDbRef.add(contact);
  }
}

@JsonSerializable()
class Contact {
  final String user;
  final String firstName;
  final String lastName;
  final String? address;
  final String? email;
  final String? phone;
  final String? company;
  final String? notes;
  final String avatar;
  final String? dotProfile;

  Contact({
    required this.user,
    required this.firstName,
    required this.lastName,
    this.address,
    this.email,
    this.phone,
    this.company,
    this.notes,
    this.dotProfile,
    required this.avatar,
  });

  String get fullName {
    return firstName + " " + lastName;
  }

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
