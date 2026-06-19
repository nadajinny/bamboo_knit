import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formattedTime(Locale locale) {
    final languageCode = locale.languageCode.toLowerCase();
    final isKorean = languageCode == 'ko';
    final isAm = _now.hour < 12;
    final periodLabel = isKorean ? (isAm ? '오전' : '오후') : (isAm ? 'AM' : 'PM');
    final hour = (_now.hour % 12 == 0 ? 12 : _now.hour % 12).toString();
    final minute = _now.minute.toString().padLeft(2, '0');
    return '$periodLabel $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '엠버의 작업실',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  _formattedTime(locale),
                  style: const TextStyle(fontSize: 24, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, bottom: 24),
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7B5C3E),
                  side: const BorderSide(color: Color(0xFF7B5C3E), width: 2.2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 42,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '작업 시작하기',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
