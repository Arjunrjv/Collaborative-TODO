import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/viewmodel/task_view_model.dart';
import '../../core/models/task_model.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final int index;

  const TaskCard({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);

    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(width: 0.5)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: SizedBox(
        height: 100,
        child: Center(
          child: ListTile(
            title: Text(
              task.title,
              style: GoogleFonts.poppins(
                  decorationThickness: 2,
                  decorationStyle: TextDecorationStyle.solid,
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            subtitle: Text(task.description,
                style: GoogleFonts.poppins(
                    decorationThickness: 2,
                    decorationStyle: TextDecorationStyle.solid,
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (val) {
                    final updated = TaskModel(
                      id: task.id,
                      title: task.title,
                      description: task.description,
                      isCompleted: val ?? false,
                      sharedWith: task.sharedWith,
                      createdAt: task.createdAt,
                      updatedAt: DateTime.now(),
                      taskDate: task.taskDate,
                    );
                    taskVM.updateTask(updated);
                  },
                  side: const BorderSide(color: Colors.black, width: 2),
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Sharing not implemented yet')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
