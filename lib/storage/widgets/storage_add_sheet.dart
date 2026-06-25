import 'package:flutter/material.dart';

import '../storage_models.dart';

class StorageAddSheet extends StatefulWidget {
  const StorageAddSheet({super.key, required this.initialMode});

  final StorageMode initialMode;

  @override
  State<StorageAddSheet> createState() => _StorageAddSheetState();
}

class _StorageAddSheetState extends State<StorageAddSheet> {
  final _nameController = TextEditingController();
  final _detailController = TextEditingController();
  final _sizeController = TextEditingController();
  NeedleKind _needleKind = NeedleKind.crochet;
  Color _selectedYarnColor = _colorOptions.first;

  static const _colorOptions = [
    Color(0xFFD5946D),
    Color(0xFF9B7A54),
    Color(0xFFE0B777),
    Color(0xFFF1E5D2),
    Color(0xFFC17A60),
    Color(0xFFD99AA5),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _detailController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final detail = _detailController.text.trim();

    if (name.isEmpty || detail.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이름과 설명을 입력해 주세요.')));
      return;
    }

    if (widget.initialMode == StorageMode.yarn) {
      Navigator.of(context).pop(
        StorageAddResult.yarn(
          YarnEntry(name: name, detail: detail, color: _selectedYarnColor),
        ),
      );
      return;
    }

    final size = _sizeController.text.trim();
    if (size.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('호수 또는 사이즈를 입력해 주세요.')));
      return;
    }

    Navigator.of(context).pop(
      StorageAddResult.needle(
        NeedleEntry(
          title: name,
          detail: detail,
          sizeLabel: size,
          kind: _needleKind,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isYarnMode = widget.initialMode == StorageMode.yarn;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0D4C6),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '보관함 추가',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4A3425),
              ),
            ),
            const SizedBox(height: 18),
            _SheetLabel(text: isYarnMode ? '실 이름' : '바늘 이름'),
            const SizedBox(height: 8),
            _SheetField(
              controller: _nameController,
              hintText: isYarnMode ? '예: 메리노 울' : '예: 코바늘 5.0mm',
            ),
            const SizedBox(height: 14),
            if (isYarnMode) ...[
              const _SheetLabel(text: '실 색상'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _colorOptions.map((color) {
                  final isSelected = color == _selectedYarnColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedYarnColor = color),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4A3425)
                              : Colors.white,
                          width: isSelected ? 3 : 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ] else ...[
              const _SheetLabel(text: '바늘 종류'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _SheetModeChip(
                    label: '코바늘',
                    isSelected: _needleKind == NeedleKind.crochet,
                    onTap: () =>
                        setState(() => _needleKind = NeedleKind.crochet),
                  ),
                  const SizedBox(width: 10),
                  _SheetModeChip(
                    label: '대바늘',
                    isSelected: _needleKind == NeedleKind.straight,
                    onTap: () =>
                        setState(() => _needleKind = NeedleKind.straight),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _SheetLabel(text: '호수'),
              const SizedBox(height: 8),
              _SheetField(
                controller: _sizeController,
                hintText: '예: 5.0',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ],
            const SizedBox(height: 14),
            _SheetLabel(text: isYarnMode ? '상세 정보' : '사용 메모'),
            const SizedBox(height: 8),
            _SheetField(
              controller: _detailController,
              hintText: isYarnMode ? '예: 면 100% · 3볼 보유' : '예: 길이 14cm · 소품용',
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF9C6840),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                isYarnMode ? '실 추가' : '바늘 추가',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetLabel extends StatelessWidget {
  const _SheetLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF7E654B),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFB39D87)),
        filled: true,
        fillColor: const Color(0xFFFFF8EF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE8D6C1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE8D6C1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF9C6840), width: 1.4),
        ),
      ),
    );
  }
}

class _SheetModeChip extends StatelessWidget {
  const _SheetModeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9C6840) : const Color(0xFFF7F0E2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF8D7257),
          ),
        ),
      ),
    );
  }
}
