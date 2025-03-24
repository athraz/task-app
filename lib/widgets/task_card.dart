import 'package:flutter/material.dart';
import 'package:taskapp/models/task.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.index,
    required this.finish,
    required this.delete,
  });

  final Task task;
  final int index;
  final Function finish;
  final Function delete;

  @override
  Widget build(BuildContext context) {
    String formattedDeadline = DateFormat('dd-MM-yyyy HH:mm').format(task.deadline);

    return Opacity(
      opacity: task.isFinished ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            task.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              Text("Deadline: $formattedDeadline"),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!task.isFinished)
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => finish(),
                  color: Colors.green,
                ),
              IconButton(icon: const Icon(Icons.delete), onPressed: () => delete()),
            ],
          ),
        ),
      ),
    );
  }
}
