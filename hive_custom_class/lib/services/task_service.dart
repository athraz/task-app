import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskService {
  static Box get tasks => Hive.box('tasks');

  static List<Task> getTasks() {
    return tasks.values
        .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  static void createTask(Task task) {
    tasks.add(task.toMap());
  }

  static void finishTask(int key) {
    final taskMap = tasks.get(key);
    if (taskMap != null) {
      Task updated = Task.fromMap(Map<String, dynamic>.from(taskMap));
      updated.isFinished = true;
      tasks.put(key, updated.toMap());
    }
  }

  static void updateTask(int key, Task task) {
    tasks.put(key, task.toMap());
  }

  static void deleteTask(int key) {
    tasks.delete(key);
  }

  static Task? getTask(int key) {
    final taskMap = tasks.get(key);
    return taskMap != null
        ? Task.fromMap(Map<String, dynamic>.from(taskMap))
        : null;
  }
}
