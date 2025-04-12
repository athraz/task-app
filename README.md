
# PPB Assignment 2: Hive Database

| Nama                      | NRP           |
|---------------------------|---------------|
|Muhammad Razan Athallah    |5025211008     |

## Introduction

## Usage

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

```dart
await Hive.initFlutter();
```

```dart
await Hive.openBox('tasks');
var tasks = await Hive.box('tasks');
```

```dart
tasks.put(1, 'Revisi Tugas Akhir');
tasks.put(2, ['Mengerjakan Tugas PPB', 'Membuat penjelasan Hive database', DateTime(2025, 4, 15).toIso8601String()]);
```

```dart
print(tasks.get(1));
print(tasks.values.toList());
```

```dart
tasks.delete(1);
```

## Hive with Custom Class

```dart
class Task {
  String title;
  String description;
  DateTime deadline;
  bool isFinished;

  Task({
    required this.title,
    required this.description,
    required this.deadline,
    this.isFinished = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'isFinished': isFinished,
    };
  }

  factory Task.fromMap(Map<dynamic, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      deadline: DateTime.parse(map['deadline']),
      isFinished: map['isFinished'] ?? false,
    );
  }
}
```

```dart
static Box get tasks => Hive.box('tasks');
```

```dart
static List<Task> getTasks() {
  return tasks.values
    .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
    .toList();
}

static void createTask(Task task) {
  tasks.add(task.toMap());
}

static void updateTask(int key, Task task) {
  tasks.put(key, task.toMap());
}

static void deleteTask(int key) {
  tasks.delete(key);
}
```
