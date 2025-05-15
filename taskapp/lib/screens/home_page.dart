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
        backgroundColor: Colors.amberAccent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, 'account');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: taskService.getTasksStream(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No task"));
          }

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
                isFinished: data['isFinished'],
                userId: data['userId'],
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
                  Navigator.pushNamed(context, 'update', arguments: {
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'create')
          .then((_) => setState(() {})),
        child: Icon(Icons.add),
      ),
    );
  }
}
