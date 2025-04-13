import 'package:flutter/material.dart';
import 'package:hive_custom_class/widgets/task_card.dart';
import 'package:hive_custom_class/services/task_service.dart';
import 'package:hive_custom_class/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<int, Task> taskMap = {};

  void loadTasks() {
    final box = TaskService.tasks;
    final map = box.toMap().map(
      (key, value) => MapEntry(
        key as int,
        Task.fromMap(Map<String, dynamic>.from(value)),
      ),
    );
    setState(() {
      taskMap = map;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: taskMap.isEmpty
          ? const Center(child: Text("No tasks found"))
          : ListView.builder(
              itemCount: taskMap.length,
              itemBuilder: (context, index) {
                final entry = taskMap.entries.elementAt(index);
                final taskKey = entry.key;
                final task = entry.value;

                return TaskCard(
                  task: task,
                  finish: () {
                    TaskService.finishTask(taskKey);
                    loadTasks();
                  },
                  update: () {
                    Navigator.pushNamed(context, '/update', arguments: {
                      'taskKey': taskKey,
                      'task': task,
                    }).then((_) => loadTasks());
                  },
                  delete: () {
                    TaskService.deleteTask(taskKey);
                    loadTasks();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, '/create').then((_) => loadTasks()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
