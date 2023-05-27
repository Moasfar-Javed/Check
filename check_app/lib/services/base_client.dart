import 'dart:convert';

import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.100.8:5000/api';

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
  
}
