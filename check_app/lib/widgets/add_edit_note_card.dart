import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:check_app/services/crud/note_service.dart';
import 'package:check_app/services/models/note_model.dart';
import 'package:check_app/utilities/pallete.dart';
import 'package:check_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEditNoteCard extends StatefulWidget {
  final Note? note;
  const AddEditNoteCard({super.key, this.note});

  @override
  State<AddEditNoteCard> createState() => _AddEditNoteCardState();
}

class _AddEditNoteCardState extends State<AddEditNoteCard> {
  final NoteService _noteService = NoteService();
  Note? note;
  late TextEditingController _title;
  late TextEditingController _text;
  late bool isFav;
  late bool isLock;

  @override
  void initState() {
    note = widget.note;
    _title = TextEditingController();
    _text = TextEditingController();

    setFavouriteState();
    setLockState();
    setControllersToNote();
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _text.dispose();
    super.dispose();
  }

  setControllersToNote() {
    if (note != null) {
      _title.text = note!.title;
      _text.text = note!.note;
    }
  }

  setFavouriteState() {
    setState(() {
      if (note == null) {
        isFav = false;
      } else {
        if (note!.isFavourite) {
          isFav = true;
        } else {
          isFav = false;
        }
      }
    });
  }

  setLockState() {
    setState(() {
      if (note == null) {
        isLock = false;
      } else {
        if (note!.isHidden) {
          isLock = true;
        } else {
          isLock = false;
        }
      }
    });
  }

  String setCreatedText() {
    if (note == null) {
      return DateFormat('dd/MM/yy hh:mm a').format(DateTime.now());
    }
    return DateFormat('dd/MM/yy hh:mm a').format(note!.createdOn);
  }

  String setAccessedText() {
    if (note == null) {
      return DateFormat('dd/MM/yy hh:mm a').format(DateTime.now());
    }
    return DateFormat('dd/MM/yy hh:mm a').format(note!.accessedOn);
  }

  void saveFavLockData() {
    if (note != null) {
      bool isFavChanged = false;
      bool isLockChanged = false;
      if (isFav != note!.isFavourite) isFavChanged = true;
      if (isLock != note!.isHidden) isLockChanged = true;
      if (isFavChanged || isLockChanged) {
        _noteService.updateNote(
            id: note!.id,
            title: note!.title,
            note: note!.note,
            isHidden: isLock,
            isFavourite: isFav);
      }
    }
  }

  void saveNoteData() {
    if (_text.text.isNotEmpty) {
      String title;
      (_title.text.isEmpty)
          ? title = _text.text.substring(0, 20)
          : title = _title.text;
      if (note != null) {
        _noteService.updateNote(
            id: note!.id,
            title: title,
            note: _text.text,
            isHidden: isLock,
            isFavourite: isFav);
      } else {
        _noteService.addNote(
            title: title,
            note: _text.text,
            isHidden: isLock,
            isFavourite: isFav);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 650,
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Card(
            color: Palette.backgroundColor,
            margin: const EdgeInsets.only(bottom: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (note != null) saveFavLockData();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                        ),
                        TextField(
                          controller: _title,
                          maxLines: null,
                          maxLength: 40,
                          decoration: const InputDecoration(
                            hintText: 'Title (optional)',
                          ),
                        ),
                        SingleChildScrollView(
                          reverse: true,
                          child: TextField(
                            minLines: 16,
                            maxLines: null,
                            maxLength: 4000,
                            controller: _text,
                            decoration: const InputDecoration(
                              hintText: 'Start jotting down things here...',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GradientButton(
                        onPressed: () {
                          if (note != null) {
                            saveNoteData();
                            Navigator.of(context).pop();
                          }
                        },
                        width: 120,
                        child: const Text('Save'),
                      ),
                      IconButton(
                        onPressed: () => setState(() => isFav = !isFav),
                        icon: isFav
                            ? const Icon(Icons.favorite, color: Colors.pink)
                            : const Icon(Icons.favorite_border),
                      ),
                      IconButton(
                        onPressed: () => setState(() => isLock = !isLock),
                        icon: isLock
                            ? const Icon(
                                Icons.lock,
                                color: Colors.yellow,
                              )
                            : const Icon(Icons.lock_open),
                      ),
                      IconButton(
                        onPressed: () {
                          if (note == null) Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}