import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/planner_provider.dart';
import '../widgets/subject_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds automatically whenever the provider calls notifyListeners()
    final planner = context.watch<PlannerProvider>();
    final subjects = planner.subjects;
    final width = MediaQuery.of(context).size.width; // responsive (Exp 3)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Countdown'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Subject'),
      ),
      body: Column(
        children: [
          _SummaryHeader(
            upcoming: planner.upcomingCount,
            progress: planner.overallProgress,
          ),
          Expanded(
            child: subjects.isEmpty
                ? const Center(
                    child: Text(
                      'No subjects yet.\nTap "Add Subject" to start!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : width < 600
                    // Phone: single column list
                    ? ListView.builder(
                        padding: const EdgeInsets.only(bottom: 90),
                        itemCount: subjects.length,
                        itemBuilder: (context, i) => _card(context, subjects[i]),
                      )
                    // Tablet / laptop: grid
                    : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 90),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 450,
                          mainAxisExtent: 185,
                        ),
                        itemCount: subjects.length,
                        itemBuilder: (context, i) => _card(context, subjects[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, subject) {
    return SubjectCard(
      subject: subject,
      onTap: () =>
          Navigator.pushNamed(context, '/detail', arguments: subject.id),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final int upcoming;
  final double progress;

  const _SummaryHeader({required this.upcoming, required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 7,
                  backgroundColor: Colors.white,
                ),
              ),
              Text('$percent%',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Overall preparation',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$upcoming upcoming exam${upcoming == 1 ? '' : 's'}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
