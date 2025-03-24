import 'package:flutter/material.dart';
import 'package:taskapp/screens/create_task_page.dart';
import 'package:taskapp/screens/home_page.dart';
import 'package:taskapp/screens/update_task_page.dart';

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
      onGenerateRoute: (settings) {
        if (settings.name == '/update') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => UpdateTaskPage(task: args['task'], index: args['index']),
          );
        }
        return null;
      },
    );
  }
}
