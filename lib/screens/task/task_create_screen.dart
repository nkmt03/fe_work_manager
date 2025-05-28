import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime dueDate = DateTime.now();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController reminderTimeController = TextEditingController();
  final TextEditingController iconController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              ListTile(
                title: Text('Due Date: ${dueDate.toString().substring(0, 16)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(dueDate),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        dueDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: reminderTimeController,
                decoration: const InputDecoration(labelText: 'Reminder Time (e.g., 1h)'),
              ),
              TextField(
                controller: iconController,
                decoration: const InputDecoration(labelText: 'Icon (e.g., gamepad)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final sessionId = await StorageService().getSessionId();
                  if (sessionId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login first')),
                    );
                    return;
                  }

                  try {
                    final task = Task(
                      id: 0, // ID sẽ được server tạo
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: dueDate,
                      category: categoryController.text,
                      status: 'NOT_COMPLETED',
                      reminderTime: reminderTimeController.text,
                      icon: iconController.text,
                      userId: 0, // userId sẽ được server xử lý
                    );

                    await ApiService().createTask(task, sessionId);
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}