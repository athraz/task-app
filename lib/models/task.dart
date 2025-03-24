class Task {
  String title;
  String description;
  DateTime deadline;
  bool isFinished;

  Task({
    required this.title,
    required this.description,
    required this.deadline,
    this.isFinished = false,
  });
}