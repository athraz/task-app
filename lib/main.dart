import 'package:flutter/material.dart';
import 'package:taskapp/screens/create_task_page.dart';
import 'package:taskapp/screens/home_page.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/create': (context) => CreateTaskPage(),
      },
    );
  }
}
