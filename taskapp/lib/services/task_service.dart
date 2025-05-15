import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskapp/models/task.dart';

class TaskService {
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) {
    return tasks.add({
      'title': task.title,
      'description': task.description,
      'deadline': task.deadline,
      'is_finished': task.isFinished,
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getTasksStream() {
    final taskStream = tasks.orderBy('deadline', descending: false).snapshots();

    return taskStream;
  }

  Future<void> updateTask(String taskId, Task task) {
    return tasks.doc(taskId).update({
      'title': task.title,
      'description': task.description,
      'deadline': task.deadline,
      'is_finished': task.isFinished,
      'updated_at': Timestamp.now(),
    });
  }

  Future<void> finishTask(String taskId) {
    return tasks.doc(taskId).update({
      'is_finished': true,
      'updated_at': Timestamp.now(),
    });
  }

  Future<void> deleteTask(String taskId) {
    return tasks.doc(taskId).delete();
  }
}