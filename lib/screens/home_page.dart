import 'package:flutter/material.dart';
import 'package:taskapp/widgets/task_card.dart';
import 'package:taskapp/services/task_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: ListView.builder(
        itemCount: TaskService.tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return TaskCard(
              task: TaskService.tasks[index],
              index: index,
              finish: () {
                setState(() {
                  TaskService.finishTask(index);
                });
              },
              update: () {
                Navigator.pushNamed(context, '/update', arguments: {
                  'task': TaskService.tasks[index],
                  'index': index,
                }).then((_) => setState(() {}));
              },
              delete: () {
                setState(() {
                  TaskService.deleteTask(index);
                });
              }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create')
          .then((_) => setState(() {})),
        child: Icon(Icons.add),
      ),
    );
  }
}
