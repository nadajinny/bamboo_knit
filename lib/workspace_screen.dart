import 'package:flutter/material.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '작업대',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
