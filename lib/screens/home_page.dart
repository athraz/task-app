import 'package:flutter/material.dart';
import 'package:taskapp/widgets/task_card.dart';
import 'package:taskapp/models/task.dart';
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
        title: Text('Awesome Quotes'),
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
              delete: () {
                setState(() {
                  TaskService.deleteTask(index);
                });
              }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            TaskService.createTask(
                Task(
                    title: 'task baru',
                    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                    deadline: DateTime.now().add(Duration(hours: 12)),
                )
            );
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
