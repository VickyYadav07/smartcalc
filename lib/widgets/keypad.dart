import 'package:flutter/material.dart';

import '../services/calculator_controller.dart';
import 'calc_button.dart';

/// The 5 x 4 grid of calculator keys. Fills whatever space the parent gives.
class Keypad extends StatelessWidget {
  const Keypad({super.key, required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;

    Widget key(String label, CalcButtonType type, VoidCallback onPressed,
            [String? semantic]) =>
        Expanded(
          child: CalcButton(
            label: label,
            type: type,
            onPressed: onPressed,
            semanticLabel: semantic,
          ),
        );

    Widget digit(String d) =>
        key(d, CalcButtonType.number, () => c.inputDigit(d));
    Widget op(String o, String name) =>
        key(o, CalcButtonType.operator, () => c.inputOperator(o), name);
    Widget row(List<Widget> keys) => Expanded(child: Row(children: keys));

    return Column(
      children: [
        row([
          key('AC', CalcButtonType.function, c.clear, 'All clear'),
          key('⌫', CalcButtonType.function, c.backspace, 'Delete'),
          key('%', CalcButtonType.function, c.inputPercent, 'Percent'),
          op('÷', 'Divide'),
        ]),
        row([digit('7'), digit('8'), digit('9'), op('×', 'Multiply')]),
        row([digit('4'), digit('5'), digit('6'), op('−', 'Subtract')]),
        row([digit('1'), digit('2'), digit('3'), op('+', 'Add')]),
        row([
          key('±', CalcButtonType.function, c.toggleSign, 'Plus minus'),
          digit('0'),
          key('.', CalcButtonType.number, c.inputDecimal, 'Decimal point'),
          key('=', CalcButtonType.equals, c.equals, 'Equals'),
        ]),
      ],
    );
  }
}
