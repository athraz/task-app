import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskapp/models/task.dart';

class TaskService {
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) {
    return tasks.add({
      'title': task.title,
      'description': task.description,
      'deadline': task.deadline,
      'isFinished': task.isFinished,
      'userId': task.userId,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getTasksStream() {
    final currentUser = FirebaseAuth.instance.currentUser;

    final taskStream = tasks
        .where('userId', isEqualTo: currentUser?.uid)
        .orderBy('deadline', descending: false)
        .snapshots();

    return taskStream;
  }

  Future<void> updateTask(String taskId, Task task) {
    return tasks.doc(taskId).update({
      'title': task.title,
      'description': task.description,
      'deadline': task.deadline,
      'isFinished': task.isFinished,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> finishTask(String taskId) {
    return tasks.doc(taskId).update({
      'isFinished': true,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteTask(String taskId) {
    return tasks.doc(taskId).delete();
  }
}