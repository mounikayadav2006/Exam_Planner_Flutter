// Data models for the Exam Countdown & Study Planner.

class Topic {
  String name;
  bool done;

  Topic({required this.name, this.done = false});
}

class Subject {
  final String id;
  String name;
  DateTime examDate;
  List<Topic> topics;

  Subject({
    required this.id,
    required this.name,
    required this.examDate,
    List<Topic>? topics,
  }) : topics = topics ?? [];

  /// Days left until the exam (0 = today, negative = already over).
  int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final exam = DateTime(examDate.year, examDate.month, examDate.day);
    return exam.difference(today).inDays;
  }

  int get doneCount => topics.where((t) => t.done).length;

  /// Progress from 0.0 to 1.0
  double get progress => topics.isEmpty ? 0 : doneCount / topics.length;

  int get progressPercent => (progress * 100).round();
}
