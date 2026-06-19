import 'package:flutter/material.dart';

import '../storage_models.dart';

class NeedleStorageCard extends StatelessWidget {
  const NeedleStorageCard({
    super.key,
    required this.item,
    required this.onFavoriteToggle,
  });

  final NeedleEntry item;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFF1E1C7),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text(
              item.sizeLabel,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9C6840),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A3425),
                  ),
                ),
                const SizedBox(height: 4),
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
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            icon: Icon(
              item.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: const Color(0xFFF0B237),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
