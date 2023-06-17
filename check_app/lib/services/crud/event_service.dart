import 'dart:async';
import 'dart:convert';

import 'package:check_app/services/auth_user.dart';
import 'package:check_app/services/models/event_model.dart';

import '../base_client.dart';
import '../defined_exceptions.dart';

class EventSevice {
  List<Event> _eventList = [];
  //creating a stream and a streamcontroller
  static final EventSevice _shared = EventSevice._sharedInstance();
  late final StreamController<List<Event>> _eventStreamController;

  EventSevice._sharedInstance() {
    _eventStreamController = StreamController<List<Event>>.broadcast(
      onListen: () {
        _eventStreamController.sink.add(_eventList);
      },
    );
  }

  factory EventSevice() => _shared;

  Stream<List<Event>> get allEvents => _eventStreamController.stream;

  // functionalities

  Future<void> cacheEvents() async {
    final allEvents = getEvents(email: AuthUser.getCurrentUser().email);
    _eventList = await allEvents;
    //_eventList.sort();
    _eventStreamController.sink.add(_eventList);
  }

  Future<List<Event>> getEvents({required email}) async {
    final response = await BaseClient()
        .getTodosApi('/events?user=$email')
        .catchError((e) {});
    if (response == null) throw ApiException;
    final jsonResponse = jsonDecode(response);
    if (jsonResponse.isEmpty) throw NoItemsException;

    //deserializing json to List<Event>
    List<Event> list = [];
    for (var eventJson in jsonResponse) {
      Event event = Event.fromJson(eventJson);
      list.add(event);
    }
    return list;
  }

  Future<void> addEvent({
    required DateTime startTime,
    required DateTime endTime,
    required String subject,
    required String color,
    required String reccuranceRule,
    required bool isAllDay,
  }) async {
    final Map<String, dynamic> requestBody = {
      "start_time": startTime.toUtc().toString(),
      "end_time": endTime.toUtc().toString(),
      "subject": subject,
      "color": color,
      "is_all_day": isAllDay
    };

    var response = await BaseClient()
        .postEventApi(
          '/user?user=${AuthUser.getCurrentUser().email}',
          requestBody,
        )
        .catchError((e) {});
    if (response == null) return;
    final jsonResponse = jsonDecode(response);
    Event eventReponse = Event.fromJson(jsonResponse);
    _eventList.add(eventReponse);
    _eventStreamController.add(_eventList);
  }

  // Future<void> updateTodo({required String id}) async {
  //   final DateTime completed = DateTime.now();
  //   final Map<String, dynamic> requestBody = {
  //     'completed_on': completed.toString(),
  //   };

  //   try {
  //     var response =
  //         await BaseClient().putTodoApi('/todos?id=$id', requestBody);

  //     Event? todoToUpdate;

  //     try {
  //       todoToUpdate = _eventList.firstWhere((todo) => todo.id == id);
  //     } catch (e) {
  //       // TODO: Handle if Event is not found
  //     }

  //     if (todoToUpdate != null) {
  //       todoToUpdate.completedOn = completed;
  //       todoToUpdate.status = 'done';
  //     }

  //     _eventStreamController.add(_eventList);
  //   } catch (e) {
  //     // TODO: Handle the error case
  //     print('Error updating Event: $e');
  //   }
  // }

  Future<void> deleteEvent({required id}) async {
    final response =
        await BaseClient().deleteEventApi('/user?id=$id').catchError((e) {});
    if (response == null) throw ApiException;
    final jsonResponse = jsonDecode(response);
    try {
      _eventList.removeWhere((event) => event.id == id);
      _eventStreamController.add(_eventList);
    } catch (e) {
      //TODO: throw exception
    }
  }
}
