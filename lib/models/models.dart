import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class Contact {
  final String firstName;
  final String? lastName;
  final String? address;
  final String? email;
  final String? phone;
  final String? company;
  final String? notes;
  final String avatar;
  final String? dotProfile;

  Contact({
    required this.firstName,
    this.lastName,
    this.address,
    this.email,
    this.phone,
    this.company,
    this.notes,
    this.dotProfile,
    required this.avatar,
  });

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
