import 'package:check_app/services/biometric_auth.dart';
import 'package:check_app/services/crud/note_service.dart';
import 'package:check_app/views/crud_note_view.dart';
import 'package:check_app/widgets/dialogs.dart';
import 'package:check_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import '../services/models/note_model.dart';

class VerticalNotesList extends StatefulWidget {
  final List<Note> notesList;
  const VerticalNotesList({super.key, required this.notesList});

  @override
  State<VerticalNotesList> createState() => _VerticalNotesListState();
}

class _VerticalNotesListState extends State<VerticalNotesList> {
  late final TextEditingController _password;
  final BiometricAuth _bioAuth = BiometricAuth();
  Dialogs _dialogs = Dialogs();
  late final List<Note> notes;
  bool _obscureText = false;
  final NoteService _noteService = NoteService();

  @override
  void initState() {
    notes = widget.notesList;
    _password = TextEditingController();

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
          onTap: () async {
            if (note.isHidden) {
              if (await BiometricAuth().canAuthenticate()) {
                if (context.mounted) {
                  _dialogs.showBioAuthDialog(bcontext: context, note: note);
                }
              } else {
                if (context.mounted) {
                  _dialogs.showAuthDialog(bcontext: context, note: note);
                }
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CrudNoteView(note: note)),
              );
            }
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
