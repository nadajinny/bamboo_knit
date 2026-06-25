import 'package:flutter/material.dart';

enum WorkspaceFilter { all, inProgress, done }

enum WorkspaceStatus { inProgress, done }

enum WorkspaceNeedleType { straight, crochet }

extension WorkspaceNeedleTypeLabel on WorkspaceNeedleType {
  String get label {
    switch (this) {
      case WorkspaceNeedleType.straight:
        return '대바늘';
      case WorkspaceNeedleType.crochet:
        return '코바늘';
    }
  }
}

class WorkspaceYarnRef {
  const WorkspaceYarnRef({required this.name, required this.color});

  final String name;
  final Color color;
}

class WorkspaceLogEntry {
  const WorkspaceLogEntry({
    required this.dateLabel,
    required this.durationText,
    required this.description,
    required this.fromProgress,
    required this.toProgress,
  });

  final String dateLabel;
  final String durationText;
  final String description;
  final int fromProgress;
  final int toProgress;
}

class WorkspaceItem {
  const WorkspaceItem({
    required this.title,
    required this.workedTimeText,
    required this.updatedText,
    required this.progress,
    required this.status,
    this.targetDate,
    this.coverImagePath,
    this.patternImagePath,
    this.note,
    this.yarns = const [],
    this.needleType = WorkspaceNeedleType.crochet,
    this.needleSizeLabel = '5.0',
    this.photoCount = 0,
    this.logs = const [],
  });

  final String title;
  final String workedTimeText;
  final String updatedText;
  final double progress;
  final WorkspaceStatus status;
  final DateTime? targetDate;
  final String? coverImagePath;
  final String? patternImagePath;
  final String? note;
  final List<WorkspaceYarnRef> yarns;
  final WorkspaceNeedleType needleType;
  final String needleSizeLabel;
  final int photoCount;
  final List<WorkspaceLogEntry> logs;

  String get needleLabel => '${needleType.label} ${needleSizeLabel}mm';

  WorkspaceItem copyWith({
    String? title,
    String? workedTimeText,
    String? updatedText,
    double? progress,
    WorkspaceStatus? status,
    DateTime? targetDate,
    bool clearTargetDate = false,
    String? coverImagePath,
    String? patternImagePath,
    String? note,
    bool clearNote = false,
    List<WorkspaceYarnRef>? yarns,
    WorkspaceNeedleType? needleType,
    String? needleSizeLabel,
    int? photoCount,
    List<WorkspaceLogEntry>? logs,
  }) {
    return WorkspaceItem(
      title: title ?? this.title,
      workedTimeText: workedTimeText ?? this.workedTimeText,
      updatedText: updatedText ?? this.updatedText,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      targetDate: clearTargetDate ? null : targetDate ?? this.targetDate,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      patternImagePath: patternImagePath ?? this.patternImagePath,
      note: clearNote ? null : note ?? this.note,
      yarns: yarns ?? this.yarns,
      needleType: needleType ?? this.needleType,
      needleSizeLabel: needleSizeLabel ?? this.needleSizeLabel,
      photoCount: photoCount ?? this.photoCount,
      logs: logs ?? this.logs,
    );
  }
}
