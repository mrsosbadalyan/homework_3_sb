import 'package:flutter/material.dart';

class NumberField extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const NumberField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(covariant NumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply(String s) {
    final parsed = int.tryParse(s) ?? widget.value;
    final clamped = parsed.clamp(0, 100);
    widget.onChanged(clamped);
  }

  void _delta(int d) {
    final now = int.tryParse(_controller.text) ?? widget.value;
    final next = (now + d).clamp(0, 100);
    _controller.text = next.toString();
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '${widget.label} (0-100)',
              border: const OutlineInputBorder(),
            ),
            onChanged: _apply,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _delta(-1),
          icon: const Icon(Icons.remove_circle_outline),
          tooltip: 'Decrease',
        ),
        IconButton(
          onPressed: () => _delta(1),
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Increase',
        ),
      ],
    );
  }
}
