import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calendar.g.dart';

class DotModel {
  static const calendarDbName = "calendar";

  CollectionReference<Calendar> get calendarDbRef {
    return FirebaseFirestore.instance
        .collection(calendarDbName)
        .withConverter<Calendar>(
      fromFirestore: (snapshots, _) {
        final data = snapshots.data()!;
        data.putIfAbsent('uid', () => snapshots.id);
        return Calendar.fromJson(data);
      },
      toFirestore: (calendar, _) {
        final data = calendar.toJson();
        data.remove('uid');
        return data;
      },
    );
  }

  Future<DocumentReference<Calendar>> addCalendar(Calendar calendar) {
    return calendarDbRef.add(calendar);
  }

  Future updateCalendar(Calendar calendar) async {
    await calendarDbRef.doc(calendar.uid!).set(calendar);
  }
}

@JsonSerializable()
class Calendar {
  final String user;
  final String Host;
  final String Guest;
  final String Date;
  final String? uid;

  Calendar({
    this.uid,
    required this.user,
    required this.Host,
    required this.Guest,
    required this.Date,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) =>
      _$CalendarFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarToJson(this);
}
