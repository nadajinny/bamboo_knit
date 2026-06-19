import 'package:flutter/material.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          '작업대 화면',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
