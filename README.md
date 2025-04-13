
# PPB Assignment 2: Hive Database

| Nama                      | NRP           |
|---------------------------|---------------|
|Muhammad Razan Athallah    |5025211008     |

## Introduction
Hive adalah database NoSQL lokal yang mampu menyimpan berbagai jenis data, mulai dari tipe sederhana seperti string dan integer hingga objek kompleks. Dengan model penyimpanan key-value, Hive tidak memerlukan proses konversi data yang rumit dan tetap mampu memberikan performa akses yang cepat. Selain itu, Hive juga mudah diintegrasikan dengan Flutter melalui package `hive_flutter`, yang mempermudah proses inisialisasi dan penggunaannya di dalam aplikasi mobile.

## Usage
Untuk menggunakan Hive, tambahkan dependensi berikut pada file `pubspec.yaml`:
```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

Lakukan inisialisasi Hive lalu buka box, yaitu wadah penyimpanan data. Pada contoh ini, box bernama `tasks` akan digunakan untuk menyimpan daftar tugas.
```dart
await Hive.initFlutter();
await Hive.openBox('tasks');
```

Untuk melakukan operasi pada box `tasks`, perlu didapatkan instancenya terlebih dahulu:
```dart
var tasks = await Hive.box('tasks');
```

Untuk memasukkan data pada box, dapat digunakan method `put(key, value)` atau `add(value)`. Untuk melakukan update atau overwrite data, cukup dengan menggunakan method put dengan value baru namun key yang sudah ada pada box.
```dart
// Menambahkan data pada box
tasks.put(1, 'Revisi Tugas Akhir');
tasks.put(2, ['Mengerjakan Tugas PPB', 'Membuat penjelasan Hive database', DateTime(2025, 4, 15).toIso8601String()]);

// Mengupdate data
tasks.put(1, ['Revisi Tugas Akhir', 'Membetulkan Bab 2-3', DateTime(2025, 4, 16).toIso8601String()]);
```

Untuk mengambil data dari box, dapat digunakan method `get(key)` untuk mengambil nilai berdasarkan key tertentu atau `values` untuk mendapatkan semua nilai dalam box.
```dart
print(tasks.get(1));
print(tasks.values.toList());
```
![Image](https://github.com/user-attachments/assets/dcade23b-33e7-4bf7-9bde-851df5b46225)

Untuk menghapus data di dalam box, kita bisa menggunakan dua method, yaitu `delete(key)` untuk menghapus data dengan key tertentu, dan `clear()` untuk menghapus semua data di dalam box.
```dart
tasks.delete(1);
tasks.clear();
```
![Image](https://github.com/user-attachments/assets/5d78a9e1-376b-48d2-9689-4a5da3709fb0)

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
