import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/planner_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_subject_screen.dart';
import 'screens/subject_detail_screen.dart';

void main() {
  runApp(
    // Provide the planner state to the whole widget tree (Exp 5)
    ChangeNotifierProvider(
      create: (_) => PlannerProvider(),
      child: const ExamPlannerApp(),
    ),
  );
}

class ExamPlannerApp extends StatelessWidget {
  const ExamPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Countdown & Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // Named routes (Exp 4)
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add': (context) => const AddSubjectScreen(),
        '/detail': (context) => const SubjectDetailScreen(),
      },
    );
  }
}
