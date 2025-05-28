class Task {
  final int id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String? category;
  final String status;
  final String? reminderTime;
  final String? icon;
  final int userId;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.category,
    required this.status,
    this.reminderTime,
    this.icon,
    required this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      category: json['category'],
      status: json['status'],
      reminderTime: json['reminderTime'],
      icon: json['icon'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'category': category,
      'status': status,
      'reminderTime': reminderTime,
      'icon': icon,
      'userId': userId,
    };
  }
}