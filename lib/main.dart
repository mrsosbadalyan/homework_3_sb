import 'package:flutter/material.dart';
import 'pages/grade_page.dart';

void main() {
  runApp(const Homework3SBApp());
}

class Homework3SBApp extends StatelessWidget {
  const Homework3SBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'homework_3_sb',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const GradePage(),
    );
  }
}
