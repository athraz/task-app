class Task {
  final String? id;
  final String title;
  final String description;
  final DateTime deadline;
  final bool isFinished;
  final String userId;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.isFinished = false,
    required this.userId,
  });
}