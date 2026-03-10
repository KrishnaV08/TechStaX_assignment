class TaskModel {
  final String id;
  final String userId;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        userId: json['user_id'],
        title: json['title'],
        isCompleted: json['is_completed'] ?? false,
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'is_completed': isCompleted,
      };

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) =>
      TaskModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt ?? this.createdAt,
      );
}
