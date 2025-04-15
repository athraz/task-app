import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/models/task.dart';
import 'package:taskapp/services/task_service.dart';

class UpdateTaskPage extends StatefulWidget {
  final Task task;
  final int index;

  const UpdateTaskPage({super.key, required this.task, required this.index});

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _selectedDateTime = widget.task.deadline;
  }

  void _selectDateTime() async {
    if (!mounted) return;

    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (!mounted || pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (!mounted || pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      TaskService.updateTask(widget.index, Task(
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: _selectedDateTime ?? DateTime.now().add(Duration(days: 1)),
      ));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Task title"),
                validator: (value) => value!.trim().isEmpty ? "Enter task title" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Task description"),
                validator: (value) => value!.trim().isEmpty ? "Enter task description" : null,
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDateTime == null
                        ? "Select deadline"
                        : "Deadline: ${DateFormat('dd-MM-yyyy HH:mm').format(_selectedDateTime!)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDateTime,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Update task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
