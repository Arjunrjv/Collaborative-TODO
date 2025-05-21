import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/viewmodel/task_view_model.dart';
import '../../core/models/task_model.dart';

class TaskInputField extends StatefulWidget {
  const TaskInputField({super.key});

  @override
  State<TaskInputField> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends State<TaskInputField> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _addTask() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) return;

    final task = TaskModel(
      id: '', // Firestore auto-generates
      title: title,
      description: desc,
      isCompleted: false,
      sharedWith: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      taskDate: DateTime.now(),
    );

    Provider.of<TaskViewModel>(context, listen: false).addTask(task);
    _titleController.clear();
    _descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Task Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descController,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _addTask,
          icon: const Icon(Icons.add),
          label: const Text('Add Task'),
        ),
      ],
    );
  }
}
