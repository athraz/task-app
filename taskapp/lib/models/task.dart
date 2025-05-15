class Task {
  final String? id;
  final String title;
  final String description;
  final DateTime deadline;
  final bool isFinished;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.isFinished = false,
  });
}