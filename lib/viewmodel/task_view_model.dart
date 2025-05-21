import 'package:flutter/material.dart';
import '../core/models/task_model.dart';
import '../data/repositories/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repo = TaskRepository();

  List<TaskModel> _allTasks = [];
  DateTime _selectedDate = DateTime.now();

  List<TaskModel> get filteredTasks => _allTasks.where((task) {
        return isSameDay(task.taskDate, _selectedDate);
      }).toList();

  DateTime get selectedDate => _selectedDate;

  TaskViewModel() {
    _listenToTasks();
  }

  void _listenToTasks() {
    _repo.streamTasks().listen((taskList) {
      _allTasks = taskList;
      notifyListeners();
    });
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) => _repo.addTask(task);
  Future<void> updateTask(TaskModel task) => _repo.updateTask(task);
  Future<void> deleteTask(String taskId) => _repo.deleteTask(taskId);

  /// Helper to quickly create task (for UI dialog)
  TaskModel createNewTask({
    required String title,
    String description = '',
  }) {
    final now = DateTime.now();
    return TaskModel(
      id: '',
      title: title,
      description: description,
      isCompleted: false,
      sharedWith: [],
      createdAt: now,
      updatedAt: now,
      taskDate: _selectedDate, // 👈 Assign to selected date
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
