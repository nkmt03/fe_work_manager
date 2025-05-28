import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null) Text(task.description!),
            Text('Due: ${DateFormat('dd/MM/yyyy HH:mm').format(task.dueDate)}'),
            Text('Status: ${task.status}'),
          ],
        ),
        trailing: task.icon != null ? Icon(Icons.star) : null,
      ),
    );
  }
}