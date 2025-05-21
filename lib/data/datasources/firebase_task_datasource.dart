import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/task_model.dart';

class FirebaseTaskDatasource {
  final _taskRef = FirebaseFirestore.instance.collection('tasks');

  Stream<List<TaskModel>> getTasks() {
    return _taskRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addTask(TaskModel task) async {
    await _taskRef.add(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    await _taskRef.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _taskRef.doc(taskId).delete();
  }
}
