import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/task_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<Task>> _upcomingTasksFuture;
  DateTime dueDate = DateTime.now().add(const Duration(days: 7)); // Mặc định 7 ngày tới

  @override
  void initState() {
    super.initState();
    _loadUpcomingTasks();
  }

  Future<void> _loadUpcomingTasks() async {
    final sessionId = await StorageService().getSessionId();
    if (sessionId != null) {
      setState(() {
        _upcomingTasksFuture = ApiService().getUpcomingTasks(sessionId, dueDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upcoming Tasks')),
      body: Column(
        children: [
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
                    _loadUpcomingTasks();
                  });
                }
              }
            },
          ),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _upcomingTasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No upcoming tasks found'));
                }

                final tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(task: tasks[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}