import 'package:check_app/services/auth_user.dart';
import 'package:check_app/services/todo_service.dart';
import 'package:check_app/utilities/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import '../../services/todo_model.dart';
import '../../widgets/add_todo_card.dart';

class TodoTab extends StatefulWidget {
  const TodoTab({super.key});

  @override
  State<TodoTab> createState() => _TodoTabState();
}

class _TodoTabState extends State<TodoTab> {
  late TodoService todoService = TodoService();
  late List<Todo> todosList = [];
  final AuthUser user = AuthUser.getCurrentUser();
  

  @override
  void initState() {
    getTodoList();
    super.initState();
    
  }

  void getTodoList() async {
    todosList = await todoService.getTodoApi(id: user.id);
    setState(() {});
  }

  Icon getIcon(String tag, String status) {
    if (status == "done") {
      return Icon(
        Icons.check_circle_outline,
        color: Palette.appColorPalette[800]!,
        size: 20,
      );
    }
    switch (tag) {
      case "work":
        return Icon(
          Icons.work_outline,
          color: Palette.appColorPalette[800]!,
          size: 20,
        );
      case "home":
        return Icon(
          Icons.home_outlined,
          color: Palette.appColorPalette[800]!,
          size: 20,
        );
      case "study":
        return Icon(
          Icons.school_outlined,
          color: Palette.appColorPalette[800]!,
          size: 20,
        );
      default:
        return Icon(
          Icons.check_circle_outline,
          color: Palette.appColorPalette[800]!,
          size: 20,
        );
    }
  }

  Color getColor(String tag, String status) {
    if (status == "done") {
      return Palette.appColorPalette[500]!;
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

  Color getTimeColor(DateTime due, String status) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(due);
    if (status == "done") {
      return Palette.text2Color;
    }
    if (difference > const Duration(minutes: 30)) {
      return Colors.redAccent;
    } else if (difference > const Duration(hours: 2)) {
      return Colors.yellowAccent;
    } else {
      return Colors.greenAccent;
    }
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
            //curve: Curves.bounceInOut,
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
      body: StreamBuilder<List<Todo>>(
        stream: TodoService().allTodos,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
              List<Todo> todoList = snapshot.data!;
              if (todosList.isEmpty) {
                return const Text('You dont have any todos');
              } else {
                return SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                    itemCount: todosList.length,
                    itemBuilder: (context, index) {
                      Todo todo = todoList[index];
                      return Card(
                        color: getColor(todo.tag, todo.status!),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipPath(
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    color: getTimeColor(todo.due, todo.status!),
                                    width: 7),
                              ),
                            ),
                            child: ListTile(
                              leading: getIcon(todo.tag, todo.status!),
                              trailing: Text(
                                '${todo.due.hour}:${todo.due.minute}',
                                style: TextStyle(
                                    color: Palette.appColorPalette[800]!),
                              ),
                              title: Text(
                                todo.description,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Palette.appColorPalette[800]!,
                                    decoration: (todo.status == "pending")
                                        ? null
                                        : TextDecoration.lineThrough),
                              ),
                              horizontalTitleGap: 0,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              dense: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}


