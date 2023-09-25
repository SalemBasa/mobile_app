import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "api/Access/SignIn";

  AuthService() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5057/");
  }

  Future<void> signOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      Navigator.of(context).pushNamed('/login');
    } catch (error) {
      print('Error during sign out: $error');
    }
  }

  Future<dynamic> signIn(String em, String ps) async {
    _endpoint = "api/Access/SignIn";
    var url = "$_baseUrl$_endpoint";

    var uri = Uri.parse(url);
    var jsonRequest = jsonEncode({'email': em, 'password': ps});

    Response response = await post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonRequest,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = data;
      String? token = result['token'];

      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        print('Token: $token');
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<dynamic> signUp(dynamic object) async {
    _endpoint = "api/Access/SignUp";
    var url = "$_baseUrl$_endpoint";

    var uri = Uri.parse(url);

    var jsonRequest = jsonEncode(object);

    Response response = await post(uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonRequest);

    if (isValidResponse(response)) {
    } else {
      throw Exception("Unknown error");
    }
  }
}

bool isValidResponse(Response response) {
  if (response.statusCode < 299) {
    return true;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    throw Exception(
        "Something bad happened please try again, Status code: ${response.statusCode}");
  }
}

String getQueryString(Map params,
    {String prefix = '&', bool inRecursion = false}) {
  String query = '';
  params.forEach((key, value) {
    if (inRecursion) {
      if (key is int) {
        key = '[$key]';
      } else if (value is List || value is Map) {
        key = '.$key';
      } else {
        key = '.$key';
      }
    }
    if (value is String || value is int || value is double || value is bool) {
      var encoded = value;
      if (value is String) {
        encoded = Uri.encodeComponent(value);
      }
      query += '$prefix$key=$encoded';
    } else if (value is DateTime) {
      query += '$prefix$key=${(value as DateTime).toIso8601String()}';
    } else if (value is List || value is Map) {
      if (value is List) value = value.asMap();
      value.forEach((k, v) {
        query +=
            getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
      });
    }
  });
  return query;
}
