enum WorkspaceFilter { all, inProgress, done }

enum WorkspaceStatus { inProgress, done }

class WorkspaceItem {
  const WorkspaceItem({
    required this.title,
    required this.durationText,
    required this.updatedText,
    required this.progress,
    required this.status,
  });

  final String title;
  final String durationText;
  final String updatedText;
  final double progress;
  final WorkspaceStatus status;
}
