import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/task_card.dart';
import '../task/task_list_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<Task>> _upcomingTasksFuture;
  DateTime dueDate = DateTime.now().add(const Duration(days: 7));

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TaskListScreen()),
            );
          },
        ),
        title: const Text(
          'Thông báo công việc',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueAccent, Colors.purpleAccent],
            ),
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent, Colors.purpleAccent],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Thông báo công việc',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildDatePicker(context),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Task>>(
                  future: _upcomingTasksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Lỗi: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Không có công việc sắp đến hạn',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                    }

                    final tasks = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
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
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
        title: Text(
          'Ngày: ${dueDate.toString().substring(0, 16)}',
          style: const TextStyle(color: Colors.blueAccent),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
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
    );
  }
}