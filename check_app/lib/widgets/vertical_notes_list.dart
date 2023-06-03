import 'package:flutter/material.dart';

import '../services/models/note_model.dart';
import '../utilities/pallete.dart';

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
          onTap: () {},
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
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
