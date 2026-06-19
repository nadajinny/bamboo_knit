import 'package:flutter/material.dart';

import 'workspace_empty_state.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '작업대',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE0E0E0), thickness: 1, height: 1),
            const Expanded(child: WorkspaceEmptyState()),
          ],
        ),
      ),
    );
  }
}
