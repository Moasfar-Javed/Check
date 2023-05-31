import 'dart:io';

import 'package:check_app/services/auth_user.dart';
import 'package:check_app/services/todo_service.dart';
import 'package:check_app/utilities/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';
import '../../services/todo_model.dart';
import '../../widgets/add_todo_card.dart';
import '../../widgets/dialogs.dart';

class TodoTab extends StatefulWidget {
  const TodoTab({super.key});

  @override
  State<TodoTab> createState() => _TodoTabState();
}

class _TodoTabState extends State<TodoTab> {
  String dropdownValue = 'All';
  late final TodoService _todoService;

  final AuthUser user = AuthUser.getCurrentUser();

  final Dialogs dialog = Dialogs();
  @override
  void initState() {
    _todoService = TodoService();
    //getTodoList();
    super.initState();
  }

  Icon _getIcon(String tag, String status, DateTime due) {
    if (status == "done") {
      return Icon(
        Icons.check_circle_outline,
        color: Palette.appColorPalette[800]!,
        size: 16,
      );
    } else if (due.isBefore(DateTime.now())) {
      return Icon(
        Icons.alarm_outlined,
        color: Palette.appColorPalette[800]!,
        size: 14,
      );
    }
    switch (tag) {
      case "work":
        return Icon(
          Icons.work_outline,
          color: Palette.appColorPalette[800]!,
          size: 14,
        );
      case "home":
        return Icon(
          Icons.home_outlined,
          color: Palette.appColorPalette[800]!,
          size: 16,
        );
      case "study":
        return Icon(
          Icons.school_outlined,
          color: Palette.appColorPalette[800]!,
          size: 16,
        );
      default:
        return Icon(
          Icons.check_circle_outline,
          color: Palette.appColorPalette[800]!,
          size: 16,
        );
    }
  }

  Color _getColor(String tag, String status, DateTime due) {
    if (status == "done") {
      return Palette.appColorPalette[500]!;
    } else if (due.isBefore(DateTime.now())) {
      return Palette.redTodo;
    }
    switch (tag) {
      case "work":
        return Palette.workTodo;
      case "home":
        return Palette.homeTodo;
      case "study":
        return Palette.studyTodo;
      default:
        return Palette.appColorPalette[500]!;
    }
  }

  List<Todo> _createTodoList(List<Todo> todosList) {
    List<Todo> todos;
    switch (dropdownValue) {
      case 'Today':
        {
          todos = todosList
              .where((todo) => todo.due.day == DateTime.now().day)
              .toList();
          Todo.sortByDueClosestToNow(todos);
          break;
        }
      case 'Pending':
        {
          todos = todosList.where((todo) => todo.status == 'pending' && !todo.due.isBefore(DateTime.now())).toList();
          Todo.sortByDueClosestToNow(todos);
          break;
        }
      case 'Missed':
        {
          todos = todosList
              .where((todo) => todo.due.isBefore(DateTime.now()) && todo.status == 'pending')
              .toList();
          break;
        }
      case 'Done':
        {
          todos = todosList.where((todo) => todo.status == 'done').toList();
          Todo.sortByCompletedOnDescending(todos);
          break;
        }
      default:
        {
          todos = todosList;
        }
    }
    return todos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.appColorPalette,
        onPressed: () {
          showAnimatedDialog(
            context: context,
            animationType: DialogTransitionType.slideFromBottom,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return const AddTodoCard();
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Palette.appColorPalette[800]!,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, left: 20),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      items: <String>[
                        'All',
                        'Today',
                        'Pending',
                        'Missed',
                        'Done'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: _todoService.cacheTodos(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          return StreamBuilder<List<Todo>>(
                            stream: _todoService.allTodos,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return const CircularProgressIndicator();
                                case ConnectionState.active:
                                  var allTodos = snapshot.data as List<Todo>;

                                  if (allTodos.isEmpty) {
                                    return const Text(
                                        'You dont have any todos');
                                  } else {
                                    var todosList = _createTodoList(allTodos);
                                    if (todosList.isEmpty){
                                      return const Text(
                                          'You dont have any todos');
                                    }
                                    return ListView.builder(
                                      padding: const EdgeInsets.only(
                                          bottom: 100, right: 10, left: 10),
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: todosList.length,
                                      itemBuilder: (context, index) {
                                        Todo todo = todosList[index];

                                        return Card(
                                          color: _getColor(
                                              todo.tag, todo.status, todo.due),
                                          elevation: 4,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 4,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: ClipPath(
                                            clipper: ShapeBorderClipper(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12))),
                                            child: ListTile(
                                              onTap: () {
                                                dialog.showTodoDetailsDialog(
                                                    context: context,
                                                    todo: todo);
                                              },
                                              trailing: Column(
                                                children: [
                                                  const SizedBox(height: 5),
                                                  _getIcon(todo.tag,
                                                      todo.status, todo.due),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    DateFormat('hh:mm a')
                                                        .format(todo.due),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Palette
                                                                .appColorPalette[
                                                            800]!),
                                                  ),
                                                  SizedBox(
                                                    height: (!Platform.isIOS ||
                                                            !Platform.isAndroid)
                                                        ? 0
                                                        : 5,
                                                  ),
                                                ],
                                              ),
                                              title: Text(
                                                todo.description,
                                                maxLines: 1,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Palette
                                                        .appColorPalette[800]!,
                                                    decoration: (todo.status ==
                                                            "pending")
                                                        ? null
                                                        : TextDecoration
                                                            .lineThrough),
                                              ),
                                              //horizontalTitleGap: 0,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              dense: true,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                default:
                                  return const CircularProgressIndicator();
                              }
                            },
                          );
                        default:
                          return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
