import 'dart:convert';

List<Note> noteFromJson(String str) =>
    List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
  String id;
  String user;
  String title;
  String note;
  bool isHidden;
  bool isFavourite;
  DateTime createdOn;
  DateTime accessedOn;

  Note({
    required this.id,
    required this.user,
    required this.title,
    required this.note,
    required this.isHidden,
    required this.isFavourite,
    required this.createdOn,
    required this.accessedOn,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["_id"],
        user: json["user"],
        title: json["title"],
        note: json["note"],
        isHidden: json["isHidden"],
        isFavourite: json["isFavourite"],
        createdOn: DateTime.parse(json["created_on"]),
        accessedOn: DateTime.parse(json["accessed_on"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "title": title,
        "note": note,
        "isHidden": isHidden,
        "isFavourite": isFavourite,
        "created_on": createdOn.toUtc().toString(),
        "accessed_on": accessedOn.toUtc().toString(),
      };

  static void sortByCreatedOn(List<Note> notes) {
    final now = DateTime.now();
    notes.sort((a, b) =>
        a.createdOn.difference(now).compareTo(b.createdOn.difference(now)));
  }

  static void sortByAccessedOn(List<Note> notes) {
    final now = DateTime.now();
    notes.sort((a, b) =>
        a.accessedOn.difference(now).compareTo(b.accessedOn.difference(now)));
  }
}
