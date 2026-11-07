import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/planner_provider.dart';
import '../widgets/subject_card.dart';

class SubjectDetailScreen extends StatelessWidget {
  const SubjectDetailScreen({super.key});

  Future<void> _addTopicDialog(BuildContext context, String subjectId) async {
    final controller = TextEditingController();
    final topic = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add topic'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Topic name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Add')),
        ],
      ),
    );
    if (topic != null && topic.isNotEmpty && context.mounted) {
      context.read<PlannerProvider>().addTopic(subjectId, topic);
    }
  }

  Future<void> _confirmDelete(BuildContext context, String subjectId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete subject?'),
        content: const Text('This will remove the subject and its topics.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<PlannerProvider>().deleteSubject(subjectId);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Subject id is passed through the named route arguments (Exp 4)
    final subjectId = ModalRoute.of(context)!.settings.arguments as String;
    final planner = context.watch<PlannerProvider>();
    final subject = planner.getById(subjectId);

    if (subject == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Subject not found')),
      );
    }

    final color = urgencyColor(subject.daysLeft);

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete subject',
            onPressed: () => _confirmDelete(context, subjectId),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTopicDialog(context, subjectId),
        tooltip: 'Add topic',
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              // Countdown banner
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  border: Border.all(color: color, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      daysLeftText(subject.daysLeft),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
                    const SizedBox(height: 4),
                    Text('Exam on ${formatDate(subject.examDate)}'),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: subject.progress,
                        minHeight: 12,
                        backgroundColor: Colors.white,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${subject.progressPercent}% complete  '
                      '(${subject.doneCount}/${subject.topics.length} topics)',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              // Topic checklist
              Expanded(
                child: subject.topics.isEmpty
                    ? const Center(
                        child: Text('No topics yet.\nTap + to add one.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 90),
                        itemCount: subject.topics.length,
                        itemBuilder: (context, i) {
                          final topic = subject.topics[i];
                          return Dismissible(
                            key: ObjectKey(topic),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => context
                                .read<PlannerProvider>()
                                .removeTopic(subjectId, i),
                            child: CheckboxListTile(
                              value: topic.done,
                              title: Text(
                                topic.name,
                                style: TextStyle(
                                  decoration: topic.done
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: topic.done ? Colors.grey : null,
                                ),
                              ),
                              onChanged: (_) => context
                                  .read<PlannerProvider>()
                                  .toggleTopic(subjectId, i),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
