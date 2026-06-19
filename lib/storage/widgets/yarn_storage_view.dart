import 'package:flutter/material.dart';

import '../storage_models.dart';
import 'yarn_storage_card.dart';

class YarnStorageView extends StatelessWidget {
  const YarnStorageView({
    super.key,
    required this.favoriteYarns,
    required this.otherYarns,
    required this.onFavoriteToggle,
  });

  final List<YarnEntry> favoriteYarns;
  final List<YarnEntry> otherYarns;
  final ValueChanged<YarnEntry> onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const Row(
          children: [
            Icon(Icons.star_rounded, size: 20, color: Color(0xFFF0B237)),
            SizedBox(width: 6),
            Text(
              '즐겨찾기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8D7257),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...favoriteYarns.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: YarnStorageCard(
              item: item,
              onFavoriteToggle: () => onFavoriteToggle(item),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '전체 실 · ${favoriteYarns.length + otherYarns.length}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF8D7257),
          ),
        ),
        const SizedBox(height: 12),
        ...otherYarns.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: YarnStorageCard(
              item: item,
              onFavoriteToggle: () => onFavoriteToggle(item),
            ),
          ),
        ),
      ],
    );
  }
}
