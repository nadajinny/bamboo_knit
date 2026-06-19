import 'package:flutter/material.dart';

class MyStorageCard extends StatelessWidget {
  const MyStorageCard({
    super.key,
    required this.title,
    required this.countText,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String countText;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8D6C1)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE3C2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 30, color: const Color(0xFF8B5E3C)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3E2A1F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    countText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8A7A6D),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFB89B7D)),
          ],
        ),
      ),
    );
  }
}
