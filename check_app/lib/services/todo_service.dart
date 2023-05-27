import 'dart:async';
import 'dart:convert';

import 'package:check_app/services/auth_user.dart';
import 'package:check_app/services/todo_model.dart';

import 'base_client.dart';
import 'defined_exceptions.dart';

class TodoService {
  AuthUser user = AuthUser.getCurrentUser();

  List<Todo> _todoList = [];
  //creating a stream and a streamcontroller
  static final TodoService _shared = TodoService._sharedInstance();
  late final StreamController<List<Todo>> _todoStreamController;

  TodoService._sharedInstance() {
    _todoStreamController = StreamController<List<Todo>>.broadcast(
      onListen: () async {
        try {
          _todoList = await getTodoApi(id: user.id);
          _todoStreamController.sink.add(_todoList);
        } catch (error) {
          // Handle error
          print('Error: $error');
        }
      },
    );
  }

  factory TodoService() => _shared;

  Stream<List<Todo>> get allTodos => _todoStreamController.stream;

  // functionalities

  Future<List<Todo>> getTodoApi({required id}) async {
    final response =
        await BaseClient().getTodosApi('/todos?id=$id').catchError((e) {});
    if (response == null) throw ApiException;
    final jsonResponse = jsonDecode(response);
    if (jsonResponse.isEmpty) NoTodosException;

    //deserializing json to List<Todo>
    List<Todo> list = [];
    for (var todoJson in jsonResponse) {
      Todo todo = Todo.fromJson(todoJson);
      list.add(todo);
    }
    return list;
  }

  Future<void> postTodoApi({
    required String description,
    required DateTime due,
    required String tag,
  }) async {
    final DateTime createdOn = DateTime.now();
    final Todo todo = Todo(
      userId: user.id,
      description: description,
      created: createdOn,
      due: due,
      tag: tag,
    );
    var response =
        await BaseClient().postTodoApi('/todos?id=${user.id}', todo).catchError((e) {});
    if (response == null) return;

    _todoList.add(todo);
    _todoStreamController.add(_todoList);
  }
}
