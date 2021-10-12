// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      uid: json['uid'] as String?,
      user: json['user'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      company: json['company'] as String,
      notes: json['notes'] as String,
      dotProfile: json['dotProfile'] as String? ?? "",
      avatar: json['avatar'] as String,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'user': instance.user,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'address': instance.address,
      'email': instance.email,
      'phone': instance.phone,
      'company': instance.company,
      'notes': instance.notes,
      'avatar': instance.avatar,
      'dotProfile': instance.dotProfile,
      'uid': instance.uid,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      uid: json['uid'] as String?,
      content: json['content'] as String,
      created: DateTime.parse(json['created'] as String),
      author: json['author'] as String,
      to: (json['to'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'author': instance.author,
      'content': instance.content,
      'created': instance.created.toIso8601String(),
      'to': instance.to,
      'uid': instance.uid,
    };
