import 'package:flutter/material.dart';

import '../storage_models.dart';
import 'needle_filter_chip.dart';
import 'needle_storage_card.dart';

class NeedleStorageView extends StatelessWidget {
  const NeedleStorageView({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.items,
    required this.onFavoriteToggle,
  });

  final NeedleFilter selectedFilter;
  final ValueChanged<NeedleFilter> onFilterSelected;
  final List<NeedleEntry> items;
  final ValueChanged<NeedleEntry> onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            NeedleFilterChip(
              label: '전체',
              isSelected: selectedFilter == NeedleFilter.all,
              onTap: () => onFilterSelected(NeedleFilter.all),
            ),
            const SizedBox(width: 10),
            NeedleFilterChip(
              label: '대바늘',
              isSelected: selectedFilter == NeedleFilter.straight,
              onTap: () => onFilterSelected(NeedleFilter.straight),
            ),
            const SizedBox(width: 10),
            NeedleFilterChip(
              label: '코바늘',
              isSelected: selectedFilter == NeedleFilter.crochet,
              onTap: () => onFilterSelected(NeedleFilter.crochet),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return NeedleStorageCard(
                item: item,
                onFavoriteToggle: () => onFavoriteToggle(item),
              );
            },
          ),
        ),
      ],
    );
  }
}
