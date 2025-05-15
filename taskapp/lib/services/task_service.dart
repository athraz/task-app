import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskapp/models/task.dart';
import 'package:taskapp/services/notification_service.dart';

class TaskService {
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  Future<String> addTask(Task task) async {
    DocumentReference docRef = await tasks.add({
      'title': task.title,
      'description': task.description,
      'deadline': task.deadline,
      'isFinished': task.isFinished,
      'userId': task.userId,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });

    return docRef.id;
  }

  Stream<QuerySnapshot> getTasksStream() {
    final currentUser = FirebaseAuth.instance.currentUser;

    final taskStream = tasks
        .where('userId', isEqualTo: currentUser?.uid)
        .orderBy('deadline', descending: false)
        .snapshots();

    return taskStream;
  }

  Future<void> updateTask(String taskId, Task task) async {
    final int notifId = taskId.hashCode;
    await NotificationService.cancelNotification(notifId + 1000);

    final DateTime reminderTime = task.deadline.subtract(Duration(minutes: 15));

    await NotificationService.createNotification(
      id: notifId + 1000,
      title: 'Task Reminder',
      body: '15 minutes before task "${task.title}" deadline!!!',
      scheduled: true,
      scheduleTime: reminderTime,
    );

    return tasks.doc(taskId).update({
      'title': task.title,
      'description': task.description,
      'deadline': task.deadline,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> finishTask(String taskId) async {
    final int notifId = taskId.hashCode;
    await NotificationService.cancelNotification(notifId + 1000);

    return tasks.doc(taskId).update({
      'isFinished': true,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteTask(String taskId) async {
    final int notifId = taskId.hashCode;
    await NotificationService.cancelNotification(notifId + 1000);

    return tasks.doc(taskId).delete();
  }
}