import 'dart:core';
import 'package:check_app/services/crud/note_service.dart';
import 'package:check_app/services/models/note_model.dart';
import 'package:check_app/utilities/pallete.dart';
import 'package:check_app/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CrudNoteView extends StatefulWidget {
  final Note? note;
  const CrudNoteView({super.key, this.note});

  @override
  State<CrudNoteView> createState() => _CrudNoteViewState();
}

class _CrudNoteViewState extends State<CrudNoteView> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardVisibility = MediaQuery.of(context).viewInsets.bottom != 0;
      if (keyboardVisibility) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    saveNoteData();
    _title.dispose();
    _text.dispose();
    super.dispose();
  }

  ScrollController _scrollController = ScrollController();

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


  String getOrMakeTitle() {
    String title;
    if (_title.text.isEmpty) {
      if (_text.text.length < 20) {
        title = _text.text;
      } else {
        title = _text.text.substring(0, 20);
      }
    } else {
      title = _title.text;
    }
    return title;
  }

  void saveNoteData() {
    if (_text.text.isNotEmpty) {
      if (note == null) {
        _noteService.addNote(
            title: getOrMakeTitle(),
            note: _text.text,
            isHidden: isLock,
            isFavourite: isFav);
      } if (note != null) {
        _noteService.updateNote(
            id: note!.id,
            title: getOrMakeTitle(),
            note: _text.text,
            isHidden: isLock,
            isFavourite: isFav);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() => isFav = !isFav);
            },
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
            onPressed: () async {
              if (note != null) {
                bool choice = await Dialogs.showConfirmationDialog(
                  context: context,
                  type: 'delete',
                  button: 'Delete',
                  text: 'Are you sure you want to delete this item?',
                );
                if (choice) {
                  _noteService.deleteNote(id: note!.id);
                  if (context.mounted) Navigator.of(context).pop();
                }
              }
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is UserScrollNotification) {
              FocusScope.of(context).unfocus();
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text(
                    'Created: ${setCreatedText()}',
                    style: const TextStyle(color: Palette.textColorDarker),
                  ),
                  Text(
                    'Accessed: ${setAccessedText()}',
                    style: const TextStyle(color: Palette.textColorDarker),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextField(
                      controller: _title,
                      maxLines: null,
                      maxLength: 40,
                      decoration: const InputDecoration(
                        hintText: 'Title (optional)',
                      ),
                    ),
                  ),
                  TextField(
                    minLines: 20,
                    maxLines: null,
                    maxLength: 4000,
                    controller: _text,
                    decoration: const InputDecoration(
                      hintText: 'Start jotting down things here...',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
