import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app1/main.dart';

void main() {
  testWidgets('menu can be searched by name', (tester) async {
    await tester.pumpWidget(const KantinBuSariApp());

    expect(find.text('KANTIN BU SARI'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Jus Alpukat');
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
    await tester.pumpAndSettle();
    final jusCardTitle = find.descendant(
      of: find.byType(FoodCard),
      matching: find.text('Jus Alpukat'),
    );
    expect(jusCardTitle, findsOneWidget);
    expect(find.text('Nasi Ayam Bakar'), findsNothing);

    await tester.tap(jusCardTitle);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();
    expect(find.text('+ 1'), findsOneWidget);

    await tester.tap(find.text('Pesanan'));
    await tester.pumpAndSettle();
    expect(find.text('Pesanan saya'), findsOneWidget);
    expect(find.text('Jus Alpukat'), findsOneWidget);
    expect(find.text('Rp10.000'), findsNWidgets(2));
  });
}
