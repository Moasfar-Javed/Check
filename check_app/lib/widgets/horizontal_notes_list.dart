import 'package:check_app/utilities/pallete.dart';
import 'package:flutter/material.dart';

import '../services/models/note_model.dart';

class HorizontalNotesList extends StatefulWidget {
  final List<Note> notesList;
  final String listFor;
  const HorizontalNotesList(
      {super.key, required this.notesList, required this.listFor});

  @override
  State<HorizontalNotesList> createState() => _HorizontalNotesListState();
}

class _HorizontalNotesListState extends State<HorizontalNotesList> {
  late final List<Note> notes;
  late final listType;

  @override
  void initState() {
    notes = widget.notesList;
    listType = widget.listFor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          Note note = notes[index];
          return SizedBox(
            width: 200,
            height: 100,
            child: Card(
              
              color: (listType == 'fav')
                  ? Palette.accentColor
                  : Palette.accentColorVariant,
              elevation: 4,
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    note.title,
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
