import 'package:flutter/material.dart';
import '../models/grade_state.dart';
import '../services/prefs_service.dart';
import '../utils/number_field.dart';
import '../widgets/homework_editor.dart';

class GradePage extends StatefulWidget {
  const GradePage({super.key});

  @override
  State<GradePage> createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {
  GradeState _state = GradeState.defaults();
  bool _loading = true;
  double? _lastResult;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await PrefsService.load();
    setState(() {
      _state = s;
      _loading = false;
    });
  }

  Future<void> _save(GradeState s) async {
    setState(() => _state = s);
    await PrefsService.save(s);
  }

  void _resetAll() async {
    await PrefsService.resetAll();
    await _load();
    setState(() => _lastResult = null);
  }

  void _resetHomework() async {
    final s = _state.copyWith(homeworks: [100, 100, 100, 100]);
    await _save(s);
  }

  void _calculate() {
    final r = _state.computeFinal();
    setState(() => _lastResult = r);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Final grade: $r'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Grade Calculator'),
        actions: [
          TextButton.icon(
            onPressed: _resetAll,
            icon: const Icon(Icons.restore, size: 18),
            label: const Text('Reset All'),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Participation (10%)
          NumberField(
            label: 'Participation & Attendance (10%)',
            value: _state.participation,
            onChanged: (v) => _save(_state.copyWith(participation: v)),
          ),
          const SizedBox(height: 12),

          // Homework (20% total, average of up to 4, can be  1...4)
          HomeworkEditor(
            values: _state.homeworks,
            onChanged: (vals) {
              final fixed = vals.take(4).toList();
              if (fixed.isEmpty) fixed.add(100);
              _save(_state.copyWith(homeworks: fixed));
            },
            onReset: _resetHomework,
          ),
          const SizedBox(height: 12),

          // Presentation (10%)
          NumberField(
            label: 'Group Presentation (10%)',
            value: _state.presentation,
            onChanged: (v) => _save(_state.copyWith(presentation: v)),
          ),
          const SizedBox(height: 12),

          // Midterm 1 (10%)
          NumberField(
            label: 'Midterm Exam 1 (10%)',
            value: _state.midterm1,
            onChanged: (v) => _save(_state.copyWith(midterm1: v)),
          ),
          const SizedBox(height: 12),

          // Midterm 2 (20%)
          NumberField(
            label: 'Midterm Exam 2 (20%)',
            value: _state.midterm2,
            onChanged: (v) => _save(_state.copyWith(midterm2: v)),
          ),
          const SizedBox(height: 12),

          // Final Project (30%)
          NumberField(
            label: 'Final Project (30%)',
            value: _state.finalProject,
            onChanged: (v) => _save(_state.copyWith(finalProject: v)),
          ),
          const SizedBox(height: 16),

          // Calculate
          FilledButton.icon(
            onPressed: _calculate,
            icon: const Icon(Icons.calculate),
            label: const Text('CALCULATE'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),

          // Result card
          if (_lastResult != null)
            Card(
              color: scheme.primaryContainer,
              child: ListTile(
                leading: const Icon(Icons.grade),
                title: const Text('Final Grade'),
                subtitle: Text(
                  '${_lastResult!.toStringAsFixed(2)} / 100',
                  style: TextStyle(
                    color: scheme.onPrimaryContainer,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),


          _weightsHelp(context),
        ],
      ),
    );
  }

  Widget _weightsHelp(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Text(
      'Weights: Participation 10%, Homework (avg of 4) 20%, '
          'Presentation 10%, Midterm 1 10%, Midterm 2 20%, Final Project 30%.',
      style: style?.copyWith(color: Colors.grey[700]),
    );
  }
}
