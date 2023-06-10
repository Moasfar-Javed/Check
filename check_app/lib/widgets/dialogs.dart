import 'package:check_app/services/crud/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/models/todo_model.dart';
import '../utilities/pallete.dart';

class Dialogs {
  TodoService _todoService = TodoService();

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

  void showTodoDetailsDialog(
      {required BuildContext context, required Todo todo}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 180),
                  child: IconButton(
                    onPressed: () async {
                      bool choice = await showConfirmationDialog(
                        context: context,
                        type: 'delete',
                        button: 'Delete',
                        text: 'Are you sure you want to delete this item?',
                      );
                      //print(choice);
                      if (choice) {
                        _todoService.deleteTodo(id: todo.id);
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
                const Text('To-do',
                    style: TextStyle(color: Palette.textColor, fontSize: 14)),
                Text(todo.description,
                    style: const TextStyle(color: Palette.textColorDarker)),
                const SizedBox(height: 10),
                const Text('Status',
                    style: TextStyle(color: Palette.textColor, fontSize: 14)),
                Text(todo.status,
                    style: const TextStyle(color: Palette.textColorDarker)),
                const SizedBox(height: 10),
                const Text('Due Date',
                    style: TextStyle(color: Palette.textColor, fontSize: 14)),
                Text('${todo.due.day}/${todo.due.month}/${todo.due.year}',
                    style: const TextStyle(color: Palette.textColorDarker)),
                const SizedBox(height: 10),
                const Text('Due Time',
                    style: TextStyle(color: Palette.textColor, fontSize: 14)),
                Text(DateFormat('hh:mm a').format(todo.due),
                    style: const TextStyle(color: Palette.textColorDarker)),
                const SizedBox(height: 25),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      _todoService.updateTodo(id: todo.id);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: Palette.success,
                    ),
                    child: const Text('Mark as Done'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
