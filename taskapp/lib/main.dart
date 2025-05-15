import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/firebase_options.dart';
import 'package:taskapp/screens/account_page.dart';
import 'package:taskapp/screens/create_task_page.dart';
import 'package:taskapp/screens/home_page.dart';
import 'package:taskapp/screens/login_page.dart';
import 'package:taskapp/screens/register_page.dart';
import 'package:taskapp/screens/update_task_page.dart';
import 'package:taskapp/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initializeNotification();
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'register': (context) => RegisterPage(),
        'account': (context) => AccountPage(),
        'home': (context) => HomePage(),
        'create': (context) => CreateTaskPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'update') {
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
