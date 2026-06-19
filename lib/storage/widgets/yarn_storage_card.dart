import 'package:flutter/material.dart';

import '../storage_models.dart';

class YarnStorageCard extends StatelessWidget {
  const YarnStorageCard({
    super.key,
    required this.item,
    required this.onFavoriteToggle,
  });

  final YarnEntry item;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0FB68F66),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.color,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 5,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A3425),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.detail,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFAF9B88),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onFavoriteToggle,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            icon: Icon(
              item.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: const Color(0xFFF0B237),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
