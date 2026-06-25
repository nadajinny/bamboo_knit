import 'package:flutter/material.dart';

import '../storage/storage_seed_data.dart';
import 'workspace_models.dart';

class WorkspaceAddScreen extends StatefulWidget {
  const WorkspaceAddScreen({super.key, this.initialItem});

  final WorkspaceItem? initialItem;

  @override
  State<WorkspaceAddScreen> createState() => _WorkspaceAddScreenState();
}

class _WorkspaceAddScreenState extends State<WorkspaceAddScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _needleSizeController;
  late final TextEditingController _noteController;
  late WorkspaceStatus _status;
  late double _progress;
  late WorkspaceNeedleType _needleType;
  DateTime? _targetDate;
  late List<WorkspaceYarnRef> _selectedYarns;

  bool get _isEditMode => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _titleController = TextEditingController(text: item?.title ?? '');
    _needleSizeController = TextEditingController(
      text: item?.needleSizeLabel ?? '5.0',
    );
    _noteController = TextEditingController(text: item?.note ?? '');
    _status = item?.status ?? WorkspaceStatus.inProgress;
    _progress = (item?.progress ?? 0) * 100;
    _needleType = item?.needleType ?? WorkspaceNeedleType.crochet;
    _targetDate = item?.targetDate;
    _selectedYarns = List.of(item?.yarns ?? const []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _needleSizeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickTargetDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 3650)),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _targetDate = picked;
    });
  }

  Future<void> _showYarnPicker() async {
    final available = initialYarnItems
        .where(
          (item) =>
              !_selectedYarns.any((selected) => selected.name == item.name),
        )
        .toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('추가할 수 있는 실이 더 없어요.')));
      return;
    }

    final selected = await showModalBottomSheet<WorkspaceYarnRef>(
      context: context,
      backgroundColor: const Color(0xFFFFFAF4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            shrinkWrap: true,
            itemCount: available.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final yarn = available[index];
              return ListTile(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pop(WorkspaceYarnRef(name: yarn.name, color: yarn.color));
                },
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                leading: CircleAvatar(radius: 12, backgroundColor: yarn.color),
                title: Text(
                  yarn.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5A4331),
                  ),
                ),
                subtitle: Text(
                  yarn.detail,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFAD9277),
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _selectedYarns = [..._selectedYarns, selected];
    });
  }

  void _removeYarn(WorkspaceYarnRef yarn) {
    setState(() {
      _selectedYarns = _selectedYarns
          .where((item) => item.name != yarn.name)
          .toList();
    });
  }

  void _save() {
    final title = _titleController.text.trim();
    final needleSize = _needleSizeController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('작품명을 입력해 주세요.')));
      return;
    }

    if (needleSize.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('바늘 호수를 입력해 주세요.')));
      return;
    }

    final normalizedProgress = _status == WorkspaceStatus.done
        ? 1.0
        : (_progress / 100).clamp(0.0, 1.0);

    final current = widget.initialItem;
    final result = WorkspaceItem(
      title: title,
      workedTimeText: current?.workedTimeText ?? '0시간 0m',
      updatedText: '방금 전',
      progress: normalizedProgress,
      status: _status,
      targetDate: _targetDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      yarns: _selectedYarns,
      needleType: _needleType,
      needleSizeLabel: needleSize,
      photoCount: current?.photoCount ?? 0,
      logs: current?.logs ?? const [],
      coverImagePath: current?.coverImagePath,
      patternImagePath: current?.patternImagePath,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final progressValue = _status == WorkspaceStatus.done
        ? 100
        : _progress.round().clamp(0, 100);

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
                  Text(
                    _isEditMode ? '작업물 수정' : '새 작품',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4E3829),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Expanded(
                    child: _ImagePlaceholderBox(
                      title: '대표 이미지',
                      icon: Icons.photo_camera_outlined,
                      filled: true,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _ImagePlaceholderBox(
                      title: '도안 이미지',
                      icon: Icons.add_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionLabel(text: '작품명 *'),
              const SizedBox(height: 10),
              _RoundedTextField(
                controller: _titleController,
                hintText: '예: 코바늘 가방',
              ),
              const SizedBox(height: 20),
              const _SectionLabel(text: '작업 상태'),
              const SizedBox(height: 10),
              _SegmentedStatusSelector(
                status: _status,
                onChanged: (status) {
                  setState(() {
                    _status = status;
                    if (status == WorkspaceStatus.done) {
                      _progress = 100;
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const _SectionLabel(text: '초기 진행률'),
                  const Spacer(),
                  Text(
                    '$progressValue%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9E683F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFFD39159),
                  inactiveTrackColor: const Color(0xFFF2E6D5),
                  thumbColor: Colors.white,
                  overlayColor: const Color(0x33D39159),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                ),
                child: Slider(
                  value: progressValue.toDouble(),
                  max: 100,
                  onChanged: _status == WorkspaceStatus.done
                      ? null
                      : (value) => setState(() => _progress = value),
                ),
              ),
              const SizedBox(height: 4),
              const _SectionLabel(text: '목표 완성일'),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickTargetDate,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 66,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFEAD8BF)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _targetDate == null
                            ? '날짜를 선택해 주세요'
                            : _formatDate(_targetDate!),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _targetDate == null
                              ? const Color(0xFFB79A7A)
                              : const Color(0xFF6A4F3B),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Color(0xFFB99B76),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const _SectionLabel(text: '사용 실'),
              const SizedBox(height: 4),
              const Text(
                '실 바구니에서 선택',
                style: TextStyle(fontSize: 14, color: Color(0xFFB39473)),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ..._selectedYarns.map(
                    (yarn) => _YarnChip(
                      yarn: yarn,
                      onDeleted: () => _removeYarn(yarn),
                    ),
                  ),
                  _AddChipButton(onTap: _showYarnPicker),
                ],
              ),
              const SizedBox(height: 22),
              const _SectionLabel(text: '바늘'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _NeedleTypeSelector(
                      selectedType: _needleType,
                      onChanged: (type) => setState(() => _needleType = type),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _RoundedTextField(
                      controller: _needleSizeController,
                      hintText: '5.0 mm',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const _SectionLabel(text: '메모'),
              const SizedBox(height: 10),
              _RoundedTextField(
                controller: _noteController,
                hintText: '작업 메모를 남겨 주세요',
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        child: SizedBox(
          height: 76,
          child: FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF9A6540),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              '저장하기',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    return '${value.year}. ${value.month.toString().padLeft(2, '0')}. ${value.day.toString().padLeft(2, '0')}';
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

class _ImagePlaceholderBox extends StatelessWidget {
  const _ImagePlaceholderBox({
    required this.title,
    required this.icon,
    this.filled = false,
  });

  final String title;
  final IconData icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: filled ? const Color(0xFFF0DFC0) : const Color(0xFFFFFAF4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE7D1B3), width: 1.4),
          gradient: filled
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF1E1C1), Color(0xFFE7D0A8)],
                  stops: [0.38, 1],
                  tileMode: TileMode.repeated,
                  transform: GradientRotation(0.75),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF9D7B57), size: filled ? 34 : 36),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9B7A57),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6A4D37),
      ),
    );
  }
}

class _RoundedTextField extends StatelessWidget {
  const _RoundedTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textAlign: textAlign,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF604734),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFFBFA382),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.55),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: maxLines > 1 ? 18 : 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFEAD8BF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFD79A62), width: 1.4),
        ),
      ),
    );
  }
}

class _SegmentedStatusSelector extends StatelessWidget {
  const _SegmentedStatusSelector({
    required this.status,
    required this.onChanged,
  });

  final WorkspaceStatus status;
  final ValueChanged<WorkspaceStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8D2),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentOption(
              label: '작업중',
              selected: status == WorkspaceStatus.inProgress,
              onTap: () => onChanged(WorkspaceStatus.inProgress),
            ),
          ),
          Expanded(
            child: _SegmentOption(
              label: '완료',
              selected: status == WorkspaceStatus.done,
              onTap: () => onChanged(WorkspaceStatus.done),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentOption extends StatelessWidget {
  const _SegmentOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x12B28B65),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: selected
                  ? const Color(0xFF9A653E)
                  : const Color(0xFFB1916B),
            ),
          ),
        ),
      ),
    );
  }
}

class _YarnChip extends StatelessWidget {
  const _YarnChip({required this.yarn, required this.onDeleted});

  final WorkspaceYarnRef yarn;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE7D4BC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
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
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(
              Icons.close_rounded,
              size: 18,
              color: Color(0xFFB3926B),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddChipButton extends StatelessWidget {
  const _AddChipButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF3E8D2),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 18, color: Color(0xFF9A6A43)),
              SizedBox(width: 6),
              Text(
                '추가',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9A6A43),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeedleTypeSelector extends StatelessWidget {
  const _NeedleTypeSelector({
    required this.selectedType,
    required this.onChanged,
  });

  final WorkspaceNeedleType selectedType;
  final ValueChanged<WorkspaceNeedleType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8D2),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: _NeedleSegment(
              label: '대바늘',
              selected: selectedType == WorkspaceNeedleType.straight,
              onTap: () => onChanged(WorkspaceNeedleType.straight),
            ),
          ),
          Expanded(
            child: _NeedleSegment(
              label: '코바늘',
              selected: selectedType == WorkspaceNeedleType.crochet,
              onTap: () => onChanged(WorkspaceNeedleType.crochet),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeedleSegment extends StatelessWidget {
  const _NeedleSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? const Color(0xFFE3D0B5) : Colors.transparent,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: selected
                  ? const Color(0xFF9A653E)
                  : const Color(0xFFB1916B),
            ),
          ),
        ),
      ),
    );
  }
}
