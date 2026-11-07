import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/planner_provider.dart';
import '../widgets/subject_card.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>(); // Form validation (Exp 8)
  final _nameController = TextEditingController();
  final _topicsController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _topicsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked); // setState (Exp 5)
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    // Topics typed as: Matrices, Laplace, Vectors
    final topics = _topicsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    context
        .read<PlannerProvider>()
        .addSubject(_nameController.text.trim(), _selectedDate!, topics);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Subject added')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Subject'), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.menu_book, size: 70),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Subject name',
                      hintText: 'e.g. Mathematics',
                      prefixIcon: Icon(Icons.book),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a subject name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name is too short';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Date picker field - validated like a normal field
                  FormField<DateTime>(
                    validator: (_) =>
                        _selectedDate == null ? 'Please pick the exam date' : null,
                    builder: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            await _pickDate();
                            state.didChange(_selectedDate);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Exam date',
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: const OutlineInputBorder(),
                              errorText: state.errorText,
                            ),
                            child: Text(
                              _selectedDate == null
                                  ? 'Tap to choose a date'
                                  : formatDate(_selectedDate!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _topicsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Syllabus topics (optional)',
                      hintText: 'Separate with commas: Matrices, Laplace, Vectors',
                      prefixIcon: Icon(Icons.checklist),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('SAVE SUBJECT',
                        style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
