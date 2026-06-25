import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bamtol_knit/main.dart';

void main() {
  testWidgets('workspace flow smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('작업대'));
    await tester.pumpAndSettle();

    expect(find.text('코바늘 가방'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('새 작품'), findsOneWidget);
    expect(find.text('저장하기'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.text('코바늘 가방').first);
    await tester.pumpAndSettle();

    expect(find.text('인증샷 모음'), findsOneWidget);
    expect(find.text('작업 로그 추가'), findsOneWidget);
  });
}
