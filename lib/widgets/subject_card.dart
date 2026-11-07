import 'package:flutter/material.dart';
import '../models/subject.dart';

/// Colour rule used across the app:
/// exam over = grey, under 7 days = red, under 15 days = orange, else green.
Color urgencyColor(int daysLeft) {
  if (daysLeft < 0) return Colors.grey;
  if (daysLeft < 7) return Colors.red;
  if (daysLeft < 15) return Colors.orange;
  return Colors.green;
}

String daysLeftText(int daysLeft) {
  if (daysLeft < 0) return 'Exam over';
  if (daysLeft == 0) return 'Exam today!';
  if (daysLeft == 1) return '1 day left';
  return '$daysLeft days left';
}

String formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const SubjectCard({super.key, required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = urgencyColor(subject.daysLeft);

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Coloured strip on the left shows urgency at a glance
            Container(width: 8, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      subject.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 18, color: color),
                        const SizedBox(width: 4),
                        Text(
                          daysLeftText(subject.daysLeft),
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatDate(subject.examDate),
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: subject.progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${subject.doneCount}/${subject.topics.length} topics '
                      '(${subject.progressPercent}%)',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
