import 'package:flutter/material.dart';
import '../models/subject.dart';

/// Global state for the whole app (Experiment 5 - Provider).
class PlannerProvider extends ChangeNotifier {
  final List<Subject> _subjects = [];

  PlannerProvider() {
    _loadSampleData();
  }

  /// Subjects sorted by nearest exam first.
  List<Subject> get subjects {
    final list = List<Subject>.from(_subjects);
    list.sort((a, b) => a.examDate.compareTo(b.examDate));
    return list;
  }

  Subject? getById(String id) {
    for (final s in _subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Average progress of all subjects (0.0 - 1.0).
  double get overallProgress {
    int total = 0;
    int done = 0;
    for (final s in _subjects) {
      total += s.topics.length;
      done += s.doneCount;
    }
    return total == 0 ? 0 : done / total;
  }

  /// Exams that have not happened yet.
  int get upcomingCount => _subjects.where((s) => s.daysLeft >= 0).length;

  void addSubject(String name, DateTime date, List<String> topicNames) {
    _subjects.add(
      Subject(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        examDate: date,
        topics: topicNames.map((t) => Topic(name: t)).toList(),
      ),
    );
    notifyListeners();
  }

  void deleteSubject(String id) {
    _subjects.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void addTopic(String subjectId, String topicName) {
    getById(subjectId)?.topics.add(Topic(name: topicName));
    notifyListeners();
  }

  void toggleTopic(String subjectId, int index) {
    final subject = getById(subjectId);
    if (subject == null) return;
    subject.topics[index].done = !subject.topics[index].done;
    notifyListeners();
  }

  void removeTopic(String subjectId, int index) {
    getById(subjectId)?.topics.removeAt(index);
    notifyListeners();
  }

  void _loadSampleData() {
    final now = DateTime.now();
    _subjects.addAll([
      Subject(
        id: '1',
        name: 'Mobile App Development',
        examDate: now.add(const Duration(days: 4)),
        topics: [
          Topic(name: 'Dart basics', done: true),
          Topic(name: 'Widgets and layouts', done: true),
          Topic(name: 'Navigation', done: false),
          Topic(name: 'State management', done: false),
        ],
      ),
      Subject(
        id: '2',
        name: 'Mathematics',
        examDate: now.add(const Duration(days: 12)),
        topics: [
          Topic(name: 'Matrices', done: true),
          Topic(name: 'Differential equations', done: false),
          Topic(name: 'Laplace transforms', done: false),
        ],
      ),
      Subject(
        id: '3',
        name: 'Data Structures',
        examDate: now.add(const Duration(days: 25)),
        topics: [
          Topic(name: 'Arrays and linked lists', done: false),
          Topic(name: 'Trees', done: false),
        ],
      ),
    ]);
  }
}
