import 'dart:async';
import 'dart:convert';

import 'package:check_app/services/auth_user.dart';
import 'package:check_app/services/todo_model.dart';

import 'base_client.dart';
import 'defined_exceptions.dart';

class TodoService {
  List<Todo> _todoList = [];
  //creating a stream and a streamcontroller
  static final TodoService _shared = TodoService._sharedInstance();
  late final StreamController<List<Todo>> _todoStreamController;

  TodoService._sharedInstance() {
    _todoStreamController = StreamController<List<Todo>>.broadcast(
      onListen: () {
        _todoStreamController.sink.add(_todoList);
      },
    );
  }

  factory TodoService() => _shared;

  Stream<List<Todo>> get allTodos => _todoStreamController.stream;

  // functionalities

  Future<void> cacheTodos() async {
    final allTodos = getTodos(id: AuthUser.getCurrentUser().id);
    _todoList = await allTodos;
    //_todoList.sort();
    _todoStreamController.sink.add(_todoList);
  }

  Future<List<Todo>> getTodos({required id}) async {
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

  Future<void> addTodo({
    required String description,
    required DateTime due,
    required String tag,
  }) async {
    final DateTime createdOn = DateTime.now();
    final Map<String, dynamic> requestBody = {
      "description": description,
      "created": createdOn.toUtc().toString(),
      "due": due.toUtc().toString(),
      "tag": tag,
    };

    var response = await BaseClient()
        .postTodoApi(
          '/todos?id=${AuthUser.getCurrentUser().id}',
          requestBody,
        )
        .catchError((e) {});
    if (response == null) return;
    final jsonResponse = jsonDecode(response);
    Todo todoReponse = Todo.fromJson(jsonResponse);
    _todoList.add(todoReponse);
    _todoStreamController.add(_todoList);
  }

  Future<void> updateTodo({required String id}) async {
    final DateTime completed = DateTime.now();
    final Map<String, dynamic> requestBody = {
      'completed_on': completed.toString(),
    };

    try {
      var response =
          await BaseClient().putTodoApi('/todos?id=$id', requestBody);

      Todo? todoToUpdate;

      try {
        todoToUpdate = _todoList.firstWhere((todo) => todo.id == id);
      } catch (e) {
        // TODO: Handle if Todo is not found
      }

      if (todoToUpdate != null) {
        todoToUpdate.completedOn = completed;
        todoToUpdate.status = 'done';
      }

      _todoStreamController.add(_todoList);
    } catch (e) {
      // TODO: Handle the error case
      print('Error updating Todo: $e');
    }
  }

  Future<void> deleteTodo({required id}) async {
    final response =
        await BaseClient().deleteTodoApi('/todos?id=$id').catchError((e) {});
    if (response == null) throw ApiException;
    final jsonResponse = jsonDecode(response);
    try {
      _todoList.removeWhere((todo) => todo.id == id);
      _todoStreamController.add(_todoList);
    } catch (e) {
      //TODO: throw exception
    }
  }
}
