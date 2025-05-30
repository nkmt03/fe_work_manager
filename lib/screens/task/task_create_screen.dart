import 'package:fe_work_manager/screens/task/task_list_screen.dart';
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
          'Tạo công việc mới',
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.add_task_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tạo công việc mới',
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
                  const SizedBox(height: 40),
                  _buildTextField(
                    controller: titleController,
                    label: 'Tiêu đề',
                    icon: Icons.title_rounded,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: descriptionController,
                    label: 'Mô tả',
                    icon: Icons.description_rounded,
                  ),
                  const SizedBox(height: 20),
                  _buildDatePicker(context),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: categoryController,
                    label: 'Danh mục',
                    icon: Icons.category_rounded,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: reminderTimeController,
                    label: 'Thời gian nhắc nhở (ví dụ: 1h)',
                    icon: Icons.alarm_rounded,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: iconController,
                    label: 'Biểu tượng (ví dụ: gamepad)',
                    icon: Icons.star_rounded,
                  ),
                  const SizedBox(height: 30),
                  _buildCreateButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
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
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blueAccent),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Container(
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
          'Ngày hết hạn: ${dueDate.toString().substring(0, 16)}',
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
              });
            }
          }
        },
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.greenAccent, Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          final sessionId = await StorageService().getSessionId();
          if (sessionId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng đăng nhập trước')),
            );
            return;
          }

          try {
            final task = Task(
              id: 0,
              title: titleController.text,
              description: descriptionController.text,
              dueDate: dueDate,
              category: categoryController.text,
              status: 'NOT_COMPLETED',
              reminderTime: reminderTimeController.text,
              icon: iconController.text,
              userId: 0,
            );

            await ApiService().createTask(task, sessionId);
            Navigator.pop(context);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi: $e')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Tạo công việc',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}