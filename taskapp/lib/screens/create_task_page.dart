import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/models/task.dart';
import 'package:taskapp/services/notification_service.dart';
import 'package:taskapp/services/task_service.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TaskService taskService = TaskService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;

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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must be logged in to add a task.')),
        );
        return;
      }

      try {
        Task newTask = Task(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          deadline: _selectedDateTime ?? DateTime.now().add(Duration(days: 1)),
          userId: currentUser.uid,
        );

        final String taskId = await taskService.addTask(newTask);
        final int notifId = taskId.hashCode;

        await NotificationService.createNotification(
          id: notifId,
          title: 'Task Created',
          body: 'Task "${_titleController.text}" successfully created',
        );

        final DateTime reminderTime = newTask.deadline.subtract(Duration(minutes: 15));

        await NotificationService.createNotification(
          id: notifId + 1000,
          title: 'Task Reminder',
          body: '15 minutes before task "${_titleController.text}" deadline!!!',
          scheduled: true,
          scheduleTime: reminderTime,
        );

        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
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
                child: const Text("Add task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
