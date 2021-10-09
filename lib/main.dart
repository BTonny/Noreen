import 'package:flutter/material.dart';
import 'package:noreen/app.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Speech Recognition",
      home: App(),
    );
  }
}
