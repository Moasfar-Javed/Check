import 'package:check_app/services/biometric_auth.dart';
import 'package:check_app/services/crud/note_service.dart';
import 'package:check_app/services/shared_prefs.dart';
import 'package:check_app/utilities/pallete.dart';
import 'package:check_app/widgets/dialogs.dart';
import 'package:check_app/widgets/gradient_button.dart';
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
  late final TextEditingController _password;
  final BiometricAuth _bioAuth = BiometricAuth();
  Dialogs _dialogs = Dialogs();

  @override
  void initState() {
    listType = widget.listFor;
    _password = TextEditingController();

    super.initState();
  }

  Row _getRowWithIcons(Note note) {
    if (note.isFavourite && note.isHidden) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
      return const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.favorite,
            color: Palette.textColorVariant,
            size: 16,
          ),
        ],
      );
    } else if (note.isHidden) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.lock,
            color: Palette.textColorVariant,
            size: 16,
          ),
        ],
      );
    }
    return const Row(
      children: [],
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
                  onTap: () async {
                    final hasPrefs = await SharedPrefs.readFromPrefs();
                    if (note.isHidden) {
                      if (await BiometricAuth().canAuthenticate() &&
                          hasPrefs != null) {
                        if (context.mounted) {
                          bool? isBioUnlocked = await _dialogs
                              .showBioAuthDialog(bcontext: context, note: note);
                              if (isBioUnlocked != null && isBioUnlocked == true){
                                if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CrudNoteView(note: note)),
                              );
                            }
                              }
                        }
                      } else {
                        if (context.mounted) {
                          _dialogs.showAuthDialog(
                              bcontext: context, note: note);
                        }
                      }
                    } else {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CrudNoteView(note: note)),
                        );
                      }
                    }
                  },
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getRowWithIcons(note),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            note.title,
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
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
