import 'package:flutter/material.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          '쇼핑 화면',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
