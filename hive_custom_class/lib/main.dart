import 'package:flutter/material.dart';
import 'package:hive_custom_class/screens/create_task_page.dart';
import 'package:hive_custom_class/screens/home_page.dart';
import 'package:hive_custom_class/screens/update_task_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('tasks');
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
            builder: (context) => UpdateTaskPage(taskKey: args['taskKey'], task: args['task']),
          );
        }
        return null;
      },
    );
  }
}
