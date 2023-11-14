class Todo {
  final String id;
  final String title;
  final String? description;
  final DateTime deadline;
  final bool isComplete;

  const Todo({
    required this.id,
    required this.title,
    this.description,
    required this.deadline,
    this.isComplete = false,
  });

  Todo copyWith({
    String? title,
    String? description,
    DateTime? deadline,
    bool? isComplete,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
