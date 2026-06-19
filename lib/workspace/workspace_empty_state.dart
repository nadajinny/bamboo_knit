import 'package:flutter/material.dart';

class WorkspaceEmptyState extends StatelessWidget {
  const WorkspaceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '아직 등록된\n작업물이 없어요 ㅠㅠ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              height: 1.18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5B412D),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '밤톨이와 함께 첫 작품을 등록해볼까?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Color(0xFFA48769)),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 28),
            label: const Text(
              '새 작품 등록',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFA06A42),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(100, 50),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
