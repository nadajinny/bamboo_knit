import 'package:flutter/material.dart';

import 'workspace_add_screen.dart';
import 'workspace_models.dart';

class WorkspaceDetailScreen extends StatefulWidget {
  const WorkspaceDetailScreen({
    super.key,
    required this.item,
    required this.onChanged,
  });

  final WorkspaceItem item;
  final ValueChanged<WorkspaceItem> onChanged;

  @override
  State<WorkspaceDetailScreen> createState() => _WorkspaceDetailScreenState();
}

class _WorkspaceDetailScreenState extends State<WorkspaceDetailScreen> {
  late WorkspaceItem _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  bool get _isDone => _item.status == WorkspaceStatus.done;

  String get _statusLabel => _isDone ? '완료' : '작업중';

  void _showPendingMessage(String label) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label 기능은 다음 단계에서 연결할게요.')));
  }

  Future<void> _editItem() async {
    final updated = await Navigator.of(context).push<WorkspaceItem>(
      MaterialPageRoute(
        builder: (context) => WorkspaceAddScreen(initialItem: _item),
      ),
    );

    if (!mounted || updated == null) {
      return;
    }

    setState(() {
      _item = updated;
    });
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final photoPreviewCount = _item.photoCount.clamp(0, 3);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _IconSquareButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      _item.title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4E3829),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _IconSquareButton(
                    icon: Icons.edit_outlined,
                    onTap: _editItem,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Stack(
                children: [
                  const _HeroArtworkPlaceholder(),
                  Positioned(
                    left: 18,
                    top: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _isDone
                              ? const Color(0xFF7F9152)
                              : const Color(0xFFD3843B),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Center(child: _FloatingCaption(text: '작품 대표 사진')),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '${(_item.progress * 100).round()}%',
                      label: '진행률',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      value: _item.workedTimeText,
                      label: '누적 시간',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(value: _item.updatedText, label: '마지막 작업'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _SectionTitle(text: '사용 재료'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: [
                  ..._item.yarns.map((yarn) => _MaterialChip(yarn: yarn)),
                  _NeedleMaterialChip(label: _item.needleLabel),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const _SectionTitle(text: '인증샷 모음'),
                  const Spacer(),
                  Text(
                    '${_item.photoCount}장',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB4916C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (var index = 0; index < photoPreviewCount; index++) ...[
                    const Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _PhotoSquarePlaceholder(),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (photoPreviewCount < 3) ...[
                    for (var index = photoPreviewCount; index < 3; index++) ...[
                      const Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _PhotoSquarePlaceholder(soft: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ],
                  const Expanded(
                    child: AspectRatio(aspectRatio: 1, child: _AddPhotoTile()),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionTitle(text: '작업 로그'),
              const SizedBox(height: 14),
              if (_item.logs.isEmpty)
                const _EmptyLogCard()
              else
                Column(
                  children: [
                    for (var index = 0; index < _item.logs.length; index++) ...[
                      _LogCard(entry: _item.logs[index]),
                      if (index != _item.logs.length - 1)
                        const SizedBox(height: 14),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 64,
                child: OutlinedButton.icon(
                  onPressed: () => _showPendingMessage('인증샷'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7ECD8),
                    foregroundColor: const Color(0xFF9A653E),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text(
                    '인증샷',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 64,
                child: FilledButton.icon(
                  onPressed: () => _showPendingMessage('작업 로그 추가'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF9A6540),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    '작업 로그 추가',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconSquareButton extends StatelessWidget {
  const _IconSquareButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF4E8D3),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(icon, color: const Color(0xFF7D5C40), size: 24),
        ),
      ),
    );
  }
}

class _HeroArtworkPlaceholder extends StatelessWidget {
  const _HeroArtworkPlaceholder();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.85,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0DEC0), Color(0xFFE4CA9D)],
            stops: [0.35, 1],
            tileMode: TileMode.repeated,
            transform: GradientRotation(0.75),
          ),
        ),
      ),
    );
  }
}

class _FloatingCaption extends StatelessWidget {
  const _FloatingCaption({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFFB48D66),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12A97A54),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF634635),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFFB3906A)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF513929),
      ),
    );
  }
}

class _MaterialChip extends StatelessWidget {
  const _MaterialChip({required this.yarn});

  final WorkspaceYarnRef yarn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE7D4BC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: yarn.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            yarn.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B4F39),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeedleMaterialChip extends StatelessWidget {
  const _NeedleMaterialChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE7D4BC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.gesture_outlined,
            size: 18,
            color: Color(0xFF92B5D7),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B4F39),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSquarePlaceholder extends StatelessWidget {
  const _PhotoSquarePlaceholder({this.soft = false});

  final bool soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: soft ? const Color(0xFFF4E9D6) : const Color(0xFFEFDDC0),
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: soft
              ? [const Color(0xFFF5EBDD), const Color(0xFFEADBC7)]
              : [const Color(0xFFF0DFC1), const Color(0xFFE4CB9D)],
          stops: const [0.35, 1],
          tileMode: TileMode.repeated,
          transform: const GradientRotation(0.75),
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3E7D3),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Icon(Icons.add_rounded, size: 34, color: Color(0xFFB28F68)),
    );
  }
}

class _LogCard extends StatelessWidget {
  const _LogCard({required this.entry});

  final WorkspaceLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10A87C53),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 74,
            height: 74,
            child: _PhotoSquarePlaceholder(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.dateLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF543A2A),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      entry.durationText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFB09069),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  entry.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: Color(0xFF7A604B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '진행률 ${entry.fromProgress}% → ${entry.toProgress}%',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFC57F47),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLogCard extends StatelessWidget {
  const _EmptyLogCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Text(
        '아직 기록된 작업 로그가 없어요.',
        style: TextStyle(fontSize: 15, color: Color(0xFFB3916D)),
      ),
    );
  }
}
