import '../models/task.dart';

class TaskService {
  static List<Task> tasks = [];

  static void createTask(Task task) {
    tasks.add(task);
  }

  static void finishTask(int index) {
    tasks[index].isFinished = true;
  }

  static void updateTask(int index, Task task) {
    tasks[index] = task;
  }

  static void deleteTask(int index) {
    tasks.removeAt(index);
  }
}