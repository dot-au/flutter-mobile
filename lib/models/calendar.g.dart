// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Calendar _$CalendarFromJson(Map<String, dynamic> json) => Calendar(
      uid: json['uid'] as String?,
      user: json['user'] as String,
      Host: json['Host'] as String,
      Guest: json['Guest'] as String,
      Date: json['Date'] as String,
    );

Map<String, dynamic> _$CalendarToJson(Calendar instance) => <String, dynamic>{
      'user': instance.user,
      'Host': instance.Host,
      'Guest': instance.Guest,
      'Date': instance.Date,
      'uid': instance.uid,
    };
