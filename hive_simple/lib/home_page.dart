import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void run () async {
    final tasks = Hive.box('tasks');

    tasks.put(1, 'Revisi Tugas Akhir');
    print(tasks.get(1));
    tasks.put(1, ['Revisi Tugas Akhir', 'Membetulkan Bab 2-3', DateTime(2025, 4, 16).toIso8601String()]);
    print(tasks.get(1));

    tasks.put(2, ['Mengerjakan Tugas PPB', 'Membuat penjelasan Hive database', DateTime(2025, 4, 15).toIso8601String()]);
    // tasks.put(3, ['Belajar Flutter', 'Menonton tutorial Flutter di YouTube', DateTime(2025, 4, 16).toIso8601String()]);
    print(tasks.values.toList());

    tasks.delete(1);
    print(tasks.values.toList());
    
    await tasks.clear();
    print(tasks.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: run,
          color: Colors.blue[200],
          child: Text('Run'),
        ),
      ),
    );
  }
}