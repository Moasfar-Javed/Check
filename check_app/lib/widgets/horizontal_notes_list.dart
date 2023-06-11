import 'package:check_app/utilities/pallete.dart';
import 'package:flutter/material.dart';

import '../services/models/note_model.dart';
import '../views/crud_note_view.dart';

class HorizontalNotesList extends StatefulWidget {
  final List<Note> notesList;
  final String listFor;
  const HorizontalNotesList(
      {super.key, required this.notesList, required this.listFor});

  @override
  State<HorizontalNotesList> createState() => _HorizontalNotesListState();
}

class _HorizontalNotesListState extends State<HorizontalNotesList> {
  late final String listType;

  @override
  void initState() {
    listType = widget.listFor;

    super.initState();
  }

  Row _getRowWithIcons(Note note) {
    if (note.isFavourite && note.isHidden) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          
          Icon(
            Icons.lock,
            color: Palette.textColorVariant,
            size: 16,
          ),
          Icon(
            Icons.favorite,
            color: Palette.textColorVariant,
            size: 16,
          ),
        ],
      );
    } else if (note.isFavourite) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(Icons.favorite, color: Palette.textColorVariant,
            size: 16,
          ),
        ],
      );
    } else if (note.isHidden) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(
            Icons.lock,
            color: Palette.textColorVariant,
            size: 16,
          ),
        ],
      );
    }
    return Row(
      children: const [],
    );
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
        itemCount: widget.notesList.length,
        itemBuilder: (context, index) {
          Note note = widget.notesList[index];
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CrudNoteView(note: note)),
                    );
                  },
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getRowWithIcons(note),
                        Text(
                          note.title,
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                      ],
                    ),
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
