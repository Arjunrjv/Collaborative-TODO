import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;
  final _tasksRef = FirebaseFirestore.instance.collection('tasks');

  Stream<List<TaskModel>> streamTasks() {
    return _tasksRef.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addTask(TaskModel task) async {
    await _tasksRef.add(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    await _tasksRef.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }

  // Future<Uri> createDynamicLink(String taskId) async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: 'https://yourapp.page.link',
  //     link: Uri.parse('https://yourapp.com/task?taskId=$taskId'),
  //     androidParameters: const AndroidParameters(
  //       packageName: 'com.example.todoapp',
  //       minimumVersion: 1,
  //     ),
  //     iosParameters: const IOSParameters(
  //       bundleId: 'com.example.todoapp',
  //       minimumVersion: '1.0.1',
  //       appStoreId: '123456789',
  //     ),
  //   );

  //   final ShortDynamicLink shortLink =
  //       await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  //   return shortLink.shortUrl;
  // }
}
