import 'package:check_app/views/crud_note_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../services/models/note_model.dart';
import '../utilities/pallete.dart';
import '../utilities/routes.dart';

class VerticalNotesList extends StatefulWidget {
  final List<Note> notesList;
  const VerticalNotesList({super.key, required this.notesList});

  @override
  State<VerticalNotesList> createState() => _VerticalNotesListState();
}

class _VerticalNotesListState extends State<VerticalNotesList> {
  late final List<Note> notes;

  @override
  void initState() {
    notes = widget.notesList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: notes.length,
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 2,
        );
      },
      itemBuilder: (context, index) {
        Note note = notes[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CrudNoteView(note: note)),
            );
           // Navigator.of(context).pushNamed(crudNotesRoute, arguments: note);
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          //dense: true,
          title: Text(
            note.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
