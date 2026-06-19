import 'package:flutter/material.dart';

import 'workspace_models.dart';

class WorkspaceCard extends StatelessWidget {
  const WorkspaceCard({super.key, required this.item});

  final WorkspaceItem item;

  bool get _isDone => item.status == WorkspaceStatus.done;

  Color get _progressColor =>
      _isDone ? const Color(0xFFA4BD6E) : const Color(0xFFC98B57);

  Color get _statusTextColor =>
      _isDone ? const Color(0xFF7C9750) : const Color(0xFFC3814D);

  Color get _statusBackgroundColor =>
      _isDone ? const Color(0xFFE5ECD5) : const Color(0xFFFCE8D9);

  String get _statusLabel => _isDone ? '완료' : '작업중';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14B99167),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ArtworkPlaceholder(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4E3827),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusBackgroundColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _statusTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '◷ ${item.durationText}    ${item.updatedText}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFA38769),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: item.progress,
                          minHeight: 7,
                          backgroundColor: const Color(0xFFF0E5D6),
                          valueColor: AlwaysStoppedAnimation(_progressColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(item.progress * 100).round()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _progressColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArtworkPlaceholder extends StatelessWidget {
  const _ArtworkPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFECDFC8),
            Color(0xFFECDFC8),
            Color(0xFFE3CDA1),
            Color(0xFFE3CDA1),
          ],
          stops: [0, 0.35, 0.35, 1],
          tileMode: TileMode.repeated,
          transform: GradientRotation(0.75),
        ),
      ),
    );
  }
}
