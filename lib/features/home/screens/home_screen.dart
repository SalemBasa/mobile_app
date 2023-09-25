import 'dart:convert';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(this.jwt, this.payload);

  factory HomeScreen.fromBase64(String jwt) =>
      HomeScreen(
        jwt,
        json.decode(
          ascii.decode(
            base64.decode(base64.normalize(jwt.split(".")[1])),
          ),
        ),
      );

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Secret Data Screen")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("${payload['username']}, here's the dummy data:"),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "This is some dummy text that you can display instead of fetching data from the /data endpoint.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      );
}
