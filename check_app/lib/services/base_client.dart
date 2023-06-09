import 'dart:convert';

import 'package:http/http.dart' as http;

const String baseUrl = 'https://check-app-server.azurewebsites.net/api';

class BaseClient {
  var client = http.Client();





  //user data

  Future<dynamic> getUserApi(String api) async {
    var uri = Uri.parse(baseUrl + api);
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> postUserApi(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.post(uri, body: payload, headers: headers);
    
    print('uri: ${uri}\n${payload}\n${response}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> putUserApi(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.put(uri, body: payload, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> deleteUserApi(String api) async {
    var uri = Uri.parse(baseUrl + api);
    var response = await client.delete(uri);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  //todo data
  Future<dynamic> getTodosApi(String api) async {
    var uri = Uri.parse(baseUrl + api);
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> postTodoApi(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.post(uri, body: payload, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> putTodoApi(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.put(uri, body: payload, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body); // Parse the JSON response
    } else {
      throw Exception(
          'Failed to update Todo. Status code: ${response.statusCode}');
    }
  }

  Future<dynamic> deleteTodoApi(String api) async {
    var uri = Uri.parse(baseUrl + api);
    var response = await client.delete(uri);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  //note data
  Future<dynamic> getNoteApi(String api) async {
    var uri = Uri.parse(baseUrl + api);
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> postNoteApi(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.post(uri, body: payload, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> putNoteApi(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.put(uri, body: payload, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body); // Parse the JSON response
    } else {
      throw Exception(
          'Failed to update Todo. Status code: ${response.statusCode}');
    }
  }

  Future<dynamic> deleteNoteApi(String api) async {
    var uri = Uri.parse(baseUrl + api);
    var response = await client.delete(uri);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  //event data
    Future<dynamic> getEventsApi(String api) async {
    var uri = Uri.parse(baseUrl + api);
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> postEventApi(String api, dynamic object) async {
    var uri = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    print(payload);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.post(uri, body: payload, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      print('Error: ${response.statusCode}');
      print(response.body);
    }
  }

  // Future<dynamic> putEventApi(String api, dynamic object) async {
  //   var uri = Uri.parse(baseUrl + api);
  //   var payload = json.encode(object);
  //   var headers = {
  //     'Content-Type': 'application/json',
  //   };
  //   var response = await client.put(uri, body: payload, headers: headers);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return json.decode(response.body); // Parse the JSON response
  //   } else {
  //     throw Exception(
  //         'Failed to update Event. Status code: ${response.statusCode}');
  //   }
  // }

  Future<dynamic> deleteEventApi(String api) async {
    var uri = Uri.parse(baseUrl + api);
    var response = await client.delete(uri);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }
}
