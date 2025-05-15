import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/models/task.dart';
import 'package:taskapp/widgets/task_card.dart';
import 'package:taskapp/services/task_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskService taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: taskService.getTasksStream(), 
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List taskList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = taskList[index];
                String taskId = document.id;

                Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                Task task = Task(
                  id: taskId,
                  title: data['title'],
                  description: data['description'],
                  deadline: (data['deadline'] as Timestamp).toDate(),
                  isFinished: data['is_finished'],
                );

                return TaskCard(
                  task: task,
                  index: index.toString(),
                  finish: () {
                    setState(() {
                      taskService.finishTask(taskId);
                    });
                  },
                  update: () {
                    Navigator.pushNamed(context, '/update', arguments: {
                      'task': task,
                      'index': taskId,
                    }).then((_) => setState(() {}));
                  },
                  delete: () {
                    setState(() {
                      taskService.deleteTask(taskId);
                    });
                  }
                );
              }
            );
          }
          else {
            return Text("No task");
          }
        }
      ),
      // body: ListView.builder(
      //   itemCount: TaskService.tasks.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return TaskCard(
      //         task: TaskService.tasks[index],
      //         index: index,
      //         finish: () {
      //           setState(() {
      //             TaskService.finishTask(index);
      //           });
      //         },
      //         update: () {
      //           Navigator.pushNamed(context, '/update', arguments: {
      //             'task': TaskService.tasks[index],
      //             'index': index,
      //           }).then((_) => setState(() {}));
      //         },
      //         delete: () {
      //           setState(() {
      //             TaskService.deleteTask(index);
      //           });
      //         }
      //     );
      //   }
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create')
          .then((_) => setState(() {})),
        child: Icon(Icons.add),
      ),
    );
  }
}
