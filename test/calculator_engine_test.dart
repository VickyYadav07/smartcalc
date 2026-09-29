import 'package:flutter_test/flutter_test.dart';
import 'package:smartcalc/services/calculator_controller.dart';
import 'package:smartcalc/utils/calculator_engine.dart';

void main() {
  final engine = CalculatorEngine();

  group('CalculatorEngine', () {
    test('respects operator precedence', () {
      expect(engine.evaluate('2+3×4'), 14);
      expect(engine.evaluate('10−6÷2'), 7);
    });

    test('handles decimals and rounding noise', () {
      expect(engine.evaluate('10÷4'), 2.5);
      expect(engine.format(engine.evaluate('0.1+0.2')), '0.3');
    });

    test('handles percentage and negative numbers', () {
      expect(engine.evaluate('50%'), 0.5);
      expect(engine.evaluate('−5×−3'), 15);
    });

    test('formats whole numbers without ".0"', () {
      expect(engine.format(40.0), '40');
    });

    test('reports errors', () {
      expect(() => engine.evaluate('5÷0'), throwsA(isA<CalcException>()));
      expect(() => engine.evaluate('5+'), throwsA(isA<CalcException>()));
      expect(() => engine.evaluate('5.5.5'), throwsA(isA<CalcException>()));
      expect(() => engine.evaluate(''), throwsA(isA<CalcException>()));
    });
  });

  group('CalculatorController', () {
    test('calculates, stores history and continues from result', () {
      final c = CalculatorController();
      c.inputDigit('2');
      c.inputDigit('5');
      c.inputOperator('+');
      c.inputDigit('1');
      c.inputDigit('5');
      c.equals();
      expect(c.history.single.text, '25 + 15 = 40');
      c.inputOperator('×');
      c.inputDigit('2');
      c.equals();
      expect(c.history.last.text, '40 × 2 = 80');
      c.clearHistory();
      expect(c.history, isEmpty);
    });

    test('replaces repeated operators and blocks a second decimal point', () {
      final c = CalculatorController();
      c.inputDigit('5');
      c.inputOperator('+');
      c.inputOperator('×');
      expect(c.displayExpression, '5 ×');
      c.inputDigit('2');
      c.inputDecimal();
      c.inputDecimal();
      expect(c.subLine, 'Invalid decimal input');
    });

    test('shows a friendly message for division by zero and empty input', () {
      final c = CalculatorController();
      c.equals();
      expect(c.subLine, 'Nothing to calculate');
      c.inputDigit('8');
      c.inputOperator('÷');
      c.inputDigit('0');
      c.equals();
      expect(c.subLine, 'Cannot divide by zero');
    });

    test('toggles sign', () {
      final c = CalculatorController();
      c.inputDigit('7');
      c.toggleSign();
      expect(c.displayExpression, '−7');
      c.toggleSign();
      expect(c.displayExpression, '7');
    });
  });
}
