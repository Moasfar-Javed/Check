import 'package:check_app/services/biometric_auth.dart';
import 'package:check_app/services/crud/event_service.dart';
import 'package:check_app/services/crud/note_service.dart';
import 'package:check_app/services/crud/todo_service.dart';
import 'package:check_app/services/crud/user_service.dart';
import 'package:check_app/services/models/event_model.dart';
import 'package:check_app/services/models/note_model.dart';
import 'package:check_app/services/shared_prefs.dart';
import 'package:check_app/views/crud_note_view.dart';
import 'package:check_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/models/todo_model.dart';
import '../utilities/pallete.dart';

class Dialogs {
  TodoService _todoService = TodoService();
  EventService _eventService = EventService();
  NoteService _noteService = NoteService();

  static Future<bool> showConfirmationDialog(
      {required BuildContext context,
      required type,
      required text,
      required button}) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
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
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 20, bottom: 30),
                    child: Text(text),
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        //flag[0] = true;
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        backgroundColor: (type == 'delete')
                            ? Colors.red.shade400
                            : (type == 'neutral')
                                ? Palette.primaryColorVariant
                                : Palette.success,
                      ),
                      child: Text(button),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  static void showLoadingDialog(
      {required BuildContext context, required String text}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
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
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 20, bottom: 30),
                    child: Text(text, textAlign: TextAlign.center),
                  ),
                  const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showTodoDetailsDialog(
      {required BuildContext context, required Todo todo}) {
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 200),
                          child: IconButton(
                            onPressed: () async {
                              bool choice = await showConfirmationDialog(
                                context: context,
                                type: 'delete',
                                button: 'Delete',
                                text:
                                    'Are you sure you want to delete this item?',
                              );
                              //print(choice);
                              if (choice) {
                                _todoService.deleteTodo(id: todo.id);
                                if (context.mounted)
                                  Navigator.of(context).pop();
                              }
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const Text('To-do',
                            style: TextStyle(
                                color: Palette.textColorVariant, fontSize: 14)),
                        Text(
                          todo.description,
                        ),
                        const SizedBox(height: 10),
                        const Text('Status',
                            style: TextStyle(
                                color: Palette.textColorVariant, fontSize: 14)),
                        Text(
                          todo.status,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Due Date',
                              style: TextStyle(
                                  color: Palette.textColorVariant,
                                  fontSize: 14),
                            ),
                            const SizedBox(
                              width: 70,
                            ),
                            todo.status != 'done'
                                ? Container()
                                : const Text(
                                    'Done Date',
                                    style: TextStyle(
                                        color: Palette.textColorVariant,
                                        fontSize: 14),
                                  ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${todo.due.day}/${todo.due.month}/${todo.due.year}',
                            ),
                            const SizedBox(
                              width: 51,
                            ),
                            todo.status != 'done'
                                ? Container()
                                : Text(
                                    '${todo.completedOn!.day}/${todo.completedOn!.month}/${todo.completedOn!.year}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('Due Time',
                                style: TextStyle(
                                    color: Palette.textColorVariant,
                                    fontSize: 14)),
                            const SizedBox(
                              width: 70,
                            ),
                            todo.status != 'done'
                                ? Container()
                                : const Text(
                                    'Done Time',
                                    style: TextStyle(
                                        color: Palette.textColorVariant,
                                        fontSize: 14),
                                  ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              DateFormat('hh:mm a').format(todo.due),
                            ),
                            const SizedBox(
                              width: 61,
                            ),
                            todo.status != 'done'
                                ? Container()
                                : Text(
                                    DateFormat('hh:mm a')
                                        .format(todo.completedOn!),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: todo.status == 'done'
                        ? Container()
                        : ElevatedButton(
                            onPressed: () {
                              _todoService.updateTodo(id: todo.id);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                              ),
                              backgroundColor: Palette.success,
                            ),
                            child: const Text('Mark as Done'),
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

  void showEventDetailsDialog(
      {required BuildContext context, required Event event}) {
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 220),
                          child: IconButton(
                            onPressed: () async {
                              bool choice = await showConfirmationDialog(
                                context: context,
                                type: 'delete',
                                button: 'Delete',
                                text:
                                    'Are you sure you want to delete this item?',
                              );
                              //print(choice);
                              if (choice) {
                                _eventService.deleteEvent(id: event.id);
                                if (context.mounted)
                                  Navigator.of(context).pop();
                              }
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const Text('Title',
                            style: TextStyle(
                                color: Palette.textColorVariant, fontSize: 14)),
                        Text(
                          event.subject,
                        ),
                        const SizedBox(height: 10),
                        event.isAllDay
                            ? const Column(
                                children: [
                                  Text(
                                    'Time',
                                    style: TextStyle(
                                        color: Palette.textColorVariant,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    'All Day',
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        'Start Date',
                                        style: TextStyle(
                                            color: Palette.textColorVariant,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 90,
                                      ),
                                      Text(
                                        'End Date',
                                        style: TextStyle(
                                            color: Palette.textColorVariant,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${event.startTime.day}/${event.startTime.month}/${event.startTime.year}',
                                      ),
                                      const SizedBox(
                                        width: 77,
                                      ),
                                      Text(
                                          '${event.endTime.day}/${event.endTime.month}/${event.endTime.year}'),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Row(
                                    children: [
                                      Text('Start Time',
                                          style: TextStyle(
                                              color: Palette.textColorVariant,
                                              fontSize: 14)),
                                      SizedBox(
                                        width: 90,
                                      ),
                                      Text(
                                        'End Time',
                                        style: TextStyle(
                                            color: Palette.textColorVariant,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat('hh:mm a')
                                            .format(event.startTime),
                                      ),
                                      const SizedBox(
                                        width: 88,
                                      ),
                                      Text(
                                        DateFormat('hh:mm a')
                                            .format(event.endTime),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        const SizedBox(height: 40),
                      ],
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

  void showAuthDialog({required BuildContext bcontext, required Note note}) {
    TextEditingController _password = TextEditingController();
    showDialog(
      context: bcontext,
      builder: (BuildContext context) {
        return Builder(
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: Palette.backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
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
                            children: [
                              const SizedBox(height: 40),
                              TextField(
                                autofocus: true,
                                maxLength: 4,
                                controller: _password,
                                autocorrect: false,
                                enableSuggestions: false,
                                obscureText: true,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_person),
                                  hintText: 'Pin',
                                  counterText: '',
                                ),
                              ),
                              const SizedBox(height: 10),
                              GradientButton(
                                onPressed: () {
                                  if (_noteService.unlockNote(_password.text)) {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CrudNoteView(note: note),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Confirm'),
                              ),
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
      },
    );
  }

  Future<bool?> showBioAuthDialog(
      {required BuildContext bcontext, required Note note}) async {
    final isAuthenticated = await BiometricAuth().authenticate();
    if (isAuthenticated) {
      final notePin = await SharedPrefs.readFromPrefs();
      if (notePin != null) {
        if (_noteService.unlockNote(notePin)) {
          if (bcontext.mounted) {
             return true;
            Navigator.of(bcontext).pop();
           
          }
        }
      }
    }
  }

  void showTimedDialog(
      {required BuildContext context,
      required String title,
      required String text}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Palette.backgroundColorShade.withOpacity(0.9),
          title: Text(title, textAlign: TextAlign.center),
          content: Text(text, textAlign: TextAlign.center),
        );
      },
    ).then((value) {});

    Future.delayed(const Duration(seconds: 2), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  static void showNotReachableDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 300,
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Icon(Icons.signal_wifi_connected_no_internet_4_rounded,
                      size: 30),
                  Text(
                      'The server is not reachable. Please check your internet connection or try again later',
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
