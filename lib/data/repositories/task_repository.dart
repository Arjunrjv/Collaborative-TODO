import '../../core/models/task_model.dart';
import '../datasources/firebase_task_datasource.dart';

class TaskRepository {
  final FirebaseTaskDatasource _datasource = FirebaseTaskDatasource();

  Stream<List<TaskModel>> streamTasks() {
    return _datasource.getTasks();
  }

  Future<void> addTask(TaskModel task) {
    return _datasource.addTask(task);
  }

  Future<void> updateTask(TaskModel task) {
    return _datasource.updateTask(task);
  }

  Future<void> deleteTask(String taskId) {
    return _datasource.deleteTask(taskId);
  }
}
