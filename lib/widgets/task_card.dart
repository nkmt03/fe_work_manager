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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            task.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Mô tả: ${task.description}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Hạn: ${DateFormat('dd/MM/yyyy HH:mm').format(task.dueDate)}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Trạng thái: ${task.status == 'NOT_COMPLETED' ? 'Chưa hoàn thành' : 'Đã hoàn thành'}',
                  style: TextStyle(
                    color: task.status == 'NOT_COMPLETED'
                        ? Colors.redAccent
                        : Colors.green,
                  ),
                ),
              ),
            ],
          ),
          trailing: task.icon != null
              ? const Icon(Icons.star, color: Colors.yellow)
              : null,
        ),
      ),
    );
  }
}