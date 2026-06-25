import 'package:flutter/material.dart';

import 'workspace_models.dart';

final initialWorkspaceItems = [
  WorkspaceItem(
    title: '코바늘 가방',
    workedTimeText: '12시간 30m',
    updatedText: '3일 전',
    progress: 0.62,
    status: WorkspaceStatus.inProgress,
    targetDate: DateTime(2026, 7, 20),
    note: '손잡이는 조금 더 길게, 바닥은 촘촘하게 떠보기',
    yarns: [
      WorkspaceYarnRef(name: '코튼 베이지', color: Color(0xFFD5946D)),
      WorkspaceYarnRef(name: '울 브라운', color: Color(0xFF9B7A54)),
    ],
    needleType: WorkspaceNeedleType.crochet,
    needleSizeLabel: '5.0',
    photoCount: 8,
    logs: [
      WorkspaceLogEntry(
        dateLabel: '6월 16일',
        durationText: '2시간 10분',
        description: '손잡이 절반 완성, 색 잘 어울린다 🐥',
        fromProgress: 48,
        toProgress: 62,
      ),
      WorkspaceLogEntry(
        dateLabel: '6월 13일',
        durationText: '1시간 40분',
        description: '바닥 코 잡기 완료',
        fromProgress: 30,
        toProgress: 48,
      ),
    ],
  ),
  WorkspaceItem(
    title: '목도리',
    workedTimeText: '5시간 10m',
    updatedText: '어제',
    progress: 0.28,
    status: WorkspaceStatus.inProgress,
    targetDate: DateTime(2026, 11, 12),
    note: '머스타드 한 볼 더 필요할 수 있음',
    yarns: [WorkspaceYarnRef(name: '머스타드', color: Color(0xFFE0B777))],
    needleType: WorkspaceNeedleType.straight,
    needleSizeLabel: '4.0',
    photoCount: 3,
    logs: [
      WorkspaceLogEntry(
        dateLabel: '6월 24일',
        durationText: '50분',
        description: '고무단 길이 점검',
        fromProgress: 18,
        toProgress: 28,
      ),
    ],
  ),
  WorkspaceItem(
    title: '수세미 3종',
    workedTimeText: '3시간 40m',
    updatedText: '2주 전',
    progress: 1,
    status: WorkspaceStatus.done,
    yarns: [WorkspaceYarnRef(name: '아이보리', color: Color(0xFFF1E5D2))],
    needleType: WorkspaceNeedleType.crochet,
    needleSizeLabel: '3.0',
    photoCount: 5,
    logs: [
      WorkspaceLogEntry(
        dateLabel: '6월 2일',
        durationText: '1시간 20분',
        description: '세 번째 수세미까지 마감 완료',
        fromProgress: 72,
        toProgress: 100,
      ),
    ],
  ),
];
