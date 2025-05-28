import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../models/task.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  // Đăng ký
  Future<AuthResponse> register(String email, String password, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // Đăng nhập
  Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Tạo task
  Future<Task> createTask(Task task, String sessionId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/create-task'),
      headers: {
        'Content-Type': 'application/json',
        'Session-Id': sessionId,
      },
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  // Lấy danh sách task
  Future<List<Task>> getTasks(String sessionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/get-tasks'),
      headers: {'Session-Id': sessionId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch tasks: ${response.body}');
    }
  }

  // Lấy task sắp đến hạn
  Future<List<Task>> getUpcomingTasks(String sessionId, DateTime dueDate) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/upcoming-tasks?dueDate=${dueDate.toIso8601String()}'),
      headers: {'Session-Id': sessionId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch upcoming tasks: ${response.body}');
    }
  }
}