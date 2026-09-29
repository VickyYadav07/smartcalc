import 'package:flutter_test/flutter_test.dart';
import 'package:smartcalc/main.dart';

void main() {
  testWidgets('SmartCalc shows title and calculates 2 × 3', (tester) async {
    await tester.pumpWidget(const SmartCalcApp());
    expect(find.text('SmartCalc'), findsOneWidget);

    for (final label in ['2', '×', '3', '=']) {
      await tester.tap(find.text(label));
      await tester.pump();
    }
    expect(find.text('2 × 3 ='), findsOneWidget); // finished equation line
    expect(find.text('2 × 3 = 6'), findsOneWidget); // history entry
  });
}
