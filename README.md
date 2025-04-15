
# PPB Assignment 2: Hive Database

| Nama                      | NRP           |
|---------------------------|---------------|
|Muhammad Razan Athallah    |5025211008     |

$~$

## Introduction
Hive adalah database NoSQL lokal yang mampu menyimpan berbagai jenis data, mulai dari tipe sederhana seperti string dan integer hingga objek kompleks. Dengan model penyimpanan key-value, Hive tidak memerlukan proses konversi data yang rumit dan tetap mampu memberikan performa akses yang cepat. Selain itu, Hive juga mudah diintegrasikan dengan Flutter melalui package `hive_flutter`, yang mempermudah proses inisialisasi dan penggunaannya di dalam aplikasi mobile.

$~$

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
![Image](https://github.com/user-attachments/assets/01d050f2-4f74-462b-9a31-bceed255da93)


Untuk menghapus data di dalam box, kita bisa menggunakan dua method, yaitu `delete(key)` untuk menghapus data dengan key tertentu, dan `clear()` untuk menghapus semua data di dalam box.
```dart
tasks.delete(1);
tasks.clear();
```
![Image](https://github.com/user-attachments/assets/1489e314-7c7a-4c80-b3d8-4323d0492a0d)

$~$

## Hive with Custom Class
Selain menyimpan data bertipe sederhana, Hive juga dapat digunakan untuk menyimpan objek dengan struktur kompleks melalui custom class. Untuk dapat menyimpan custom class ke dalam Hive, objek tersebut perlu dikonversi terlebih dahulu menjadi tipe data yang dapat dikenali Hive, seperti `Map<String, dynamic>`. Konversi ini dilakukan dengan membuat method `toMap()` pada class untuk menyimpan data, dan `fromMap()` sebagai factory constructor untuk membaca kembali data dari Hive menjadi objek asli.
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

Berikut operasi CRUD yang dapat dilakukan dengan custom class Task:
```dart
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
```

$~$

## References
- https://github.com/isar/hive
- https://github.com/o-ifeanyi/db_benchmarks
