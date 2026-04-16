import 'package:shared_preferences/shared_preferences.dart';
import 'task_model.dart';

class TaskRepository {
  static const String _tasksKey = 'cached_tasks';

  Future<List<Task>> getTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList(_tasksKey);
      
      if (tasksJson != null) {
        return tasksJson.map((jsonStr) => Task.fromJson(jsonStr)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((task) => task.toJson()).toList();
      await prefs.setStringList(_tasksKey, tasksJson);
    } catch (e) {
      // Handle error natively or log it
    }
  }
}
