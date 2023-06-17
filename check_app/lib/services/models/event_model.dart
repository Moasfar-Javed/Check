import 'dart:convert';

List<Event> eventsFromJson(String str) =>
    List<Event>.from(json.decode(str).map((x) => Event.fromJson(x)));

String eventsToJson(List<Event> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Event {
  String id;
  String user;
  DateTime startTime;
  DateTime endTime;
  String subject;
  String color;
  bool isAllDay;

  Event({
    required this.id,
    required this.user,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.color,
    required this.isAllDay,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["_id"],
        user: json["user"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        subject: json["subject"],
        color: json["color"],
        isAllDay: json["is_all_day"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime,
        "subject": subject,
        "color": color,
        "is_all_day": isAllDay,
      };
}
