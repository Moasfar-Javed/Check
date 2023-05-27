import 'dart:convert';

List<Todo> todoFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  String? id;
  String userId;
  String description;
  DateTime created;
  DateTime due;
  String? status;
  DateTime? completedOn;
  String tag;

  Todo({
    this.id,
    required this.userId,
    required this.description,
    required this.created,
    required this.due,
    this.status,
    required this.tag,
    this.completedOn,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["_id"],
        userId: json["user_id"],
        description: json["description"],
        created: DateTime.parse(json["created"]),
        due: DateTime.parse(json["due"]),
        status: json["status"],
        completedOn: (json["completed_on"] != null) ? DateTime.parse(json["completed_on"]) : null, 
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "description": description,
        "created": created.toUtc().toString(),
        "due": due.toUtc().toString(),
        "completed_on": completedOn?.toUtc().toString(),
        "tag": tag
      };
}
