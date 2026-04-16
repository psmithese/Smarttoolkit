import 'package:flutter/material.dart';
import 'task_model.dart';
import 'task_repository.dart';

enum TaskFilter { all, active, completed }

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;

  List<Task> _tasks = [];
  bool _isLoading = false;
  TaskFilter _filter = TaskFilter.all;

  TaskViewModel(this._repository) {
    loadTasks();
  }

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  TaskFilter get filter => _filter;

  List<Task> get filteredTasks {
    switch (_filter) {
      case TaskFilter.active:
        return _tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get activeCount => _tasks.where((t) => !t.isCompleted).length;

  double get completionRatio =>
      _tasks.isEmpty ? 0 : completedCount / _tasks.length;

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _repository.getTasks();
    // Sort: incomplete high-priority first, then by date
    _tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      if (a.priority.index != b.priority.index) {
        return b.priority.index.compareTo(a.priority.index);
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(
    String title,
    String description, {
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
  }) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      priority: priority,
      dueDate: dueDate,
    );

    _tasks.insert(0, newTask);
    _sortTasks();
    notifyListeners();
    await _repository.saveTasks(_tasks);
  }

  Future<void> updateTask(
    String id,
    String title,
    String description, {
    TaskPriority? priority,
    DateTime? dueDate,
    bool clearDueDate = false,
  }) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
        clearDueDate: clearDueDate,
      );
      _sortTasks();
      notifyListeners();
      await _repository.saveTasks(_tasks);
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      _sortTasks();
      notifyListeners();
      await _repository.saveTasks(_tasks);
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
    await _repository.saveTasks(_tasks);
  }

  Future<void> clearCompletedTasks() async {
    _tasks.removeWhere((task) => task.isCompleted);
    notifyListeners();
    await _repository.saveTasks(_tasks);
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      if (a.priority.index != b.priority.index) {
        return b.priority.index.compareTo(a.priority.index);
      }
      return b.createdAt.compareTo(a.createdAt);
    });
  }
}
