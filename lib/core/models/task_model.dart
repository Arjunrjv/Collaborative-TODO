class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final List<String> sharedWith; // emails or userIds
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime taskDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.sharedWith,
    required this.createdAt,
    required this.updatedAt,
    required this.taskDate,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      taskDate: map['taskDate'] != null
          ? DateTime.parse(map['taskDate'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'sharedWith': sharedWith,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'taskDate': taskDate.toIso8601String(),
    };
  }
}
