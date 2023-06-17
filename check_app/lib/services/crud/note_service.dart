import 'dart:async';
import 'dart:convert';
import 'package:check_app/services/auth_user.dart';
import '../base_client.dart';
import '../defined_exceptions.dart';
import '../models/note_model.dart';

class NoteService {
  List<Note> _noteList = [];
  //creating a stream and a streamcontroller
  static final NoteService _shared = NoteService._sharedInstance();
  late final StreamController<List<Note>> _noteStreamController;

  NoteService._sharedInstance() {
    _noteStreamController = StreamController<List<Note>>.broadcast(
      onListen: () {
        _noteStreamController.sink.add(_noteList);
      },
    );
  }

  factory NoteService() => _shared;

  Stream<List<Note>> get allNotes => _noteStreamController.stream;

  // functionalities
  Future<void> cacheNotes() async {
    print(AuthUser.getCurrentUser().email);
    final allNotes = getNotes(email: AuthUser.getCurrentUser().email);

    _noteList = await allNotes;

    _noteStreamController.sink.add(_noteList);
  }

  Future<List<Note>> getNotes({required email}) async {
    final response =
        await BaseClient().getTodosApi('/notes?user=$email').catchError((e) {});
    if (response == null) throw ApiException;
    final jsonResponse = jsonDecode(response);
    if (jsonResponse.isEmpty) NoItemsException;

    //deserializing json to List<Note>
    List<Note> list = [];
    for (var noteJson in jsonResponse) {
      Note note = Note.fromJson(noteJson);
      list.add(note);
    }
    return list;
  }

  Future<void> addNote({
    required String title,
    required String note,
    required bool isHidden,
    required bool isFavourite,
  }) async {
    final DateTime createdOn = DateTime.now();
    final DateTime accessedOn = DateTime.now();
    final Map<String, dynamic> requestBody = {
      "title": title,
      "note": note,
      "isHidden": isHidden,
      "isFavourite": isFavourite,
      "created_on": createdOn.toUtc().toString(),
      "accessed_on": accessedOn.toUtc().toString()
    };
    print(requestBody.entries);
    var response = await BaseClient()
        .postNoteApi(
          '/notes?user=${AuthUser.getCurrentUser().email}',
          requestBody,
        )
        .catchError((e) {});
    if (response == null) return;
    final jsonResponse = jsonDecode(response);
    Note noteReponse = Note.fromJson(jsonResponse);
    _noteList.add(noteReponse);
    _noteStreamController.add(_noteList);
  }

  Future<void> updateNote({
    required String id,
    required String title,
    required String note,
    required bool isHidden,
    required bool isFavourite,
  }) async {
    final DateTime accessedOn = DateTime.now();
    final Map<String, dynamic> requestBody = {
      "title": title,
      "note": note,
      "isHidden": isHidden,
      "isFavourite": isFavourite,
      "accessed_on": accessedOn.toUtc().toString()
    };

    try {
      var response =
          await BaseClient().putNoteApi('/notes?id=$id', requestBody);

      Note? noteToUpdate;

      try {
        noteToUpdate = _noteList.firstWhere((note) => note.id == id);
      } catch (e) {
        // TODO: Handle if Note is not found
      }

      if (noteToUpdate != null) {
        noteToUpdate.title = title;
        noteToUpdate.note = note;
        noteToUpdate.isHidden = isHidden;
        noteToUpdate.isFavourite = isFavourite;
        noteToUpdate.accessedOn = accessedOn;
      }

      _noteStreamController.add(_noteList);
    } catch (e) {
      // TODO: Handle the error case
      print('Error updating Note: $e');
    }
  }

  Future<void> deleteNote({required id}) async {
    final response =
        await BaseClient().deleteTodoApi('/notes?id=$id').catchError((e) {});
    if (response == null) throw ApiException;
    final jsonResponse = jsonDecode(response);
    try {
      _noteList.removeWhere((note) => note.id == id);
      _noteStreamController.add(_noteList);
    } catch (e) {
      //TODO: throw exception
    }
  }

  bool unlockNote(String enteredPin){
    return AuthUser.getCurrentUser().notesPin == enteredPin;
  }
}
