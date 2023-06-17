import 'package:check_app/services/crud/event_service.dart';
import 'package:check_app/services/crud/todo_service.dart';
import 'package:check_app/services/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/models/todo_model.dart';
import '../utilities/pallete.dart';

class Dialogs {
  TodoService _todoService = TodoService();
  EventService _eventService = EventService();
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
                    child: Text(text),
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
                                        width: 70,
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
                                        width: 51,
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
                                        width: 70,
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
                                        width: 61,
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


}
