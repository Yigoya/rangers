import 'package:flutter/material.dart';

class Step extends StatefulWidget {
  const Step({super.key});

  @override
  State<Step> createState() => _StepState();
}

class _StepState extends State<Step> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stepper(steps: const []),
      ),
    );
  }
}
