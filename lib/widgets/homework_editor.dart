import 'package:flutter/material.dart';

class HomeworkEditor extends StatelessWidget {
  final List<int> values;
  final ValueChanged<List<int>> onChanged;
  final VoidCallback onReset;

  const HomeworkEditor({
    super.key,
    required this.values,
    required this.onChanged,
    required this.onReset,
  });

  void _updateItem(int index, int newVal) {
    final copy = List<int>.from(values);
    copy[index] = newVal.clamp(0, 100);
    onChanged(copy);
  }

  void _add() {
    if (values.length >= 4) return;
    final copy = List<int>.from(values)..add(100);
    onChanged(copy);
  }

  void _remove(int index) {
    if (values.length <= 1) return;
    final copy = List<int>.from(values)..removeAt(index);
    onChanged(copy);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Homeworks (4 total, 20% combined)',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                IconButton(
                  onPressed: values.length < 4 ? _add : null,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add homework (max 4)',
                ),
                IconButton(
                  onPressed: values.length > 1 ? () => _remove(values.length - 1) : null,
                  icon: const Icon(Icons.remove),
                  tooltip: 'Remove last',
                ),
                const SizedBox(width: 6),
                OutlinedButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < values.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _HomeworkRow(
                  index: i,
                  value: values[i],
                  onChanged: (v) => _updateItem(i, v),
                  onRemove: values.length > 1 ? () => _remove(i) : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeworkRow extends StatefulWidget {
  final int index;
  final int value;
  final ValueChanged<int> onChanged;
  final VoidCallback? onRemove;

  const _HomeworkRow({
    required this.index,
    required this.value,
    required this.onChanged,
    this.onRemove,
  });

  @override
  State<_HomeworkRow> createState() => _HomeworkRowState();
}

class _HomeworkRowState extends State<_HomeworkRow> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(covariant _HomeworkRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _c.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _apply(String s) {
    final parsed = int.tryParse(s) ?? widget.value;
    final clamped = parsed.clamp(0, 100);
    widget.onChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('HW ${widget.index + 1}'),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _c,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '0-100',
              border: OutlineInputBorder(),
            ),
            onChanged: _apply,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: widget.onRemove,
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Remove this',
        ),
      ],
    );
  }
}
