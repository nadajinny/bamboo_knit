import 'package:flutter/material.dart';

import 'workspace_card.dart';
import 'workspace_empty_state.dart';
import 'workspace_models.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  WorkspaceFilter _selectedFilter = WorkspaceFilter.all;

  static const _items = [
    WorkspaceItem(
      title: '코바늘 가방',
      durationText: '12시간 30분',
      updatedText: '3일 전',
      progress: 0.62,
      status: WorkspaceStatus.inProgress,
    ),
    WorkspaceItem(
      title: '목도리',
      durationText: '5시간 10분',
      updatedText: '어제',
      progress: 0.28,
      status: WorkspaceStatus.inProgress,
    ),
    WorkspaceItem(
      title: '수세미 3종',
      durationText: '3시간 40분',
      updatedText: '2주 전',
      progress: 1,
      status: WorkspaceStatus.done,
    ),
  ];

  List<WorkspaceItem> get _filteredItems {
    switch (_selectedFilter) {
      case WorkspaceFilter.all:
        return _items;
      case WorkspaceFilter.inProgress:
        return _items
            .where((item) => item.status == WorkspaceStatus.inProgress)
            .toList();
      case WorkspaceFilter.done:
        return _items
            .where((item) => item.status == WorkspaceStatus.done)
            .toList();
    }
  }

  void _selectFilter(WorkspaceFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    return SafeArea(
      child: Stack(
        children: [
          ColoredBox(
            color: Colors.white,
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
                  const Divider(
                    color: Color(0xFFE0E0E0),
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChipButton(
                          label: '전체',
                          isSelected: _selectedFilter == WorkspaceFilter.all,
                          onTap: () => _selectFilter(WorkspaceFilter.all),
                        ),
                        const SizedBox(width: 6),
                        _FilterChipButton(
                          label: '작업중',
                          isSelected:
                              _selectedFilter == WorkspaceFilter.inProgress,
                          onTap: () =>
                              _selectFilter(WorkspaceFilter.inProgress),
                        ),
                        const SizedBox(width: 6),
                        _FilterChipButton(
                          label: '완료',
                          isSelected: _selectedFilter == WorkspaceFilter.done,
                          onTap: () => _selectFilter(WorkspaceFilter.done),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? const WorkspaceEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 84),
                            itemCount: filteredItems.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return WorkspaceCard(item: item);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, bottom: 24),
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF9C6840),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(54, 54),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Icon(Icons.add, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
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
        width: 64,
        height: 34,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9C6840) : const Color(0xFFF9EEDA),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF8D7257),
          ),
        ),
      ),
    );
  }
}
