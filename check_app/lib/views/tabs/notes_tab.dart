import 'package:check_app/utilities/routes.dart';
import 'package:check_app/widgets/gradient_button.dart';
import 'package:check_app/widgets/horizontal_notes_list.dart';
import 'package:flutter/material.dart';
import '../../services/crud/note_service.dart';
import '../../services/models/note_model.dart';
import '../../utilities/pallete.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/vertical_notes_list.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({super.key});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  late final NoteService _noteService;


  @override
  void initState() {
    _noteService = NoteService();
    //getTodoList();
    //_noteService.cacheNotes();
    super.initState();
  }

  List<Note> _createFavNotesList(List<Note> notesList) {
    List<Note> notes =
        notesList.where((note) => note.isFavourite == true).toList();
    Note.sortByCreatedOn(notes);
    return notes;
  }

  List<Note> _createRecentNotesList(List<Note> notesList) {
    notesList.sort((a, b) => b.accessedOn.compareTo(a.accessedOn));
    DateTime now = DateTime.now();

    List<Note> notes = notesList
        .where((note) => note.accessedOn.isBefore(now))
        .take(5)
        .toList();

    return notes;
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(crudNotesRoute);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color(0xFFFC9E3A),
              Color(0xFFC43726),
            ]),
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: const Icon(Icons.add),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: _noteService.cacheNotes(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return StreamBuilder<List<Note>>(
                        stream: _noteService.allNotes,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 1.3,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ));
                            case ConnectionState.active:
                              var allNotes = snapshot.data as List<Note>;
                              if (allNotes.isEmpty) {
                                return const Center(
                                    child: Text('\nYou dont have any notes'));
                              } else {
                                var favList = _createFavNotesList(allNotes);
                                var recentList =
                                    _createRecentNotesList(allNotes);
                                Note.sortByCreatedOn(allNotes);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        'Recents',
                                        style: TextStyle(
                                            color: Palette.textColorVariant),
                                      ),
                                    ),
                                    (recentList.isEmpty)
                                        ? const Text('You have no recent notes')
                                        : HorizontalNotesList(
                                            notesList: recentList,
                                            listFor: 'recents'),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Favourites',
                                        style: TextStyle(
                                            color: Palette.textColorVariant),
                                      ),
                                    ),
                                    (favList.isEmpty)
                                        ? const Text(
                                            'You have no favourite notes')
                                        : HorizontalNotesList(
                                            notesList: favList, listFor: 'fav'),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'All Notes',
                                        style: TextStyle(
                                            color: Palette.textColorVariant),
                                      ),
                                    ),
                                    VerticalNotesList(notesList: allNotes),
                                    const SizedBox(height: 60)
                                  ],
                                );
                              }
                            default:
                              return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 1.3,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ));
                          }
                        },
                      );
                    default:
                      return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
