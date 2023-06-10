import 'dart:convert';

List<Todo> todoFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  String id;
  String email;
  String description;
  DateTime created;
  DateTime due;
  String status;
  DateTime? completedOn;
  String tag;

  Todo({
    required this.id,
    required this.email,
    required this.description,
    required this.created,
    required this.due,
    required this.status,
    required this.tag,
    this.completedOn,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["_id"],
        email: json["email"],
        description: json["description"],
        created: DateTime.parse(json["created"]),
        due: DateTime.parse(json["due"]),
        status: json["status"],
        completedOn: (json["completed_on"] != null)
            ? DateTime.parse(json["completed_on"])
            : null,
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "description": description,
        "created": created.toUtc().toString(),
        "due": due.toUtc().toString(),
        "completed_on": completedOn?.toUtc().toString(),
        "tag": tag
      };

  static void sortByCompletedOnDescending(List<Todo> todos) {
    todos.sort((a, b) => b.completedOn!.compareTo(a.completedOn!));
  }

  static void sortByDueClosestToNow(List<Todo> todos) {
    final now = DateTime.now();
    todos.sort((a, b) {
      // Compare the status
      if (a.status == 'done' && b.status != 'done') {
        return 1; // 'done' should be after non-'done'
      } else if (a.status != 'done' && b.status == 'done') {
        return -1; // 'done' should be after non-'done'
      }

      // If both todos have the same status, compare the due dates
      int dateComparison =
          a.due.difference(now).compareTo(b.due.difference(now));

      // If the due dates are different, return the comparison result
      if (dateComparison != 0) {
        return dateComparison;
      }

      // If the due dates and status are the same, maintain their original order
      return 0;
    });
  }
}
