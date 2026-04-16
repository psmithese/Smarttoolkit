import 'dart:convert';

enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final TaskPriority priority;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.priority = TaskPriority.medium,
    this.dueDate,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    TaskPriority? priority,
    DateTime? dueDate,
    bool clearDueDate = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'priority': priority.index,
      'dueDate': dueDate?.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      priority: TaskPriority.values[map['priority'] ?? 1],
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  bool get isOverdue =>
      dueDate != null &&
      !isCompleted &&
      dueDate!.isBefore(DateTime.now());
}
