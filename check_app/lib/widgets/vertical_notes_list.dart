import 'package:check_app/services/crud/note_service.dart';
import 'package:check_app/views/crud_note_view.dart';
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
  late final List<Note> notes;
    late final TextEditingController _password;
  bool _obscureText = false;
  final NoteService _noteService = NoteService();

  @override
  void initState() {
    notes = widget.notesList;
    _password = TextEditingController();

    super.initState();
  }

  void showEventDetailsDialog(
      {required BuildContext context, required Note note}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 300,
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lock_person),
                          TextField(
                            maxLength: 4,
                            controller: _password,
                            obscureText: _obscureText,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              hintText: 'Pin',
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GradientButton(
                              onPressed: () {
                                if (_noteService.unlockNote(_password.text)) {}
                              },
                              child: const Text('Unlock')),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
