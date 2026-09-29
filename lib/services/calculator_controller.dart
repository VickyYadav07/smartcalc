import 'package:flutter/foundation.dart';

import '../models/history_item.dart';
import '../utils/calculator_engine.dart';

/// Holds the calculator state and turns button presses into an expression.
/// The UI listens to this object and rebuilds when it changes.
class CalculatorController extends ChangeNotifier {
  static const int _maxLength = 60;

  final CalculatorEngine _engine = CalculatorEngine();
  final List<HistoryItem> _history = [];

  String _expression = '';
  String _preview = '';
  String? _message;
  bool _justEvaluated = false;

  /// Expression as typed (e.g. "2+3×4"), formatted for display.
  String get displayExpression => _engine.prettify(_expression);

  /// True when [subLine] is an error / hint message.
  bool get hasMessage => _message != null;

  /// Second display line: message, finished equation, or live preview.
  String get subLine {
    if (_message != null) return _message!;
    if (_justEvaluated && _history.isNotEmpty) return '${_history.last.expression} =';
    if (_preview.isNotEmpty) return '= $_preview';
    return '';
  }

  List<HistoryItem> get history => List.unmodifiable(_history);

  // ---- helpers -------------------------------------------------------------

  String get _lastChar => _expression.isEmpty ? '' : _expression[_expression.length - 1];

  /// The number currently being typed (digits and '.'), or '' if none.
  String get _lastNumber {
    var i = _expression.length;
    while (i > 0 && CalculatorEngine.isNumberChar(_expression[i - 1])) {
      i--;
    }
    return _expression.substring(i);
  }

  void _refresh() {
    _preview = '';
    final hasOperation = _expression.length > 1 &&
        _expression.substring(1).contains(RegExp(r'[+−×÷%]'));
    if (!_justEvaluated && hasOperation) {
      try {
        _preview = _engine.format(_engine.evaluate(_expression));
      } on CalcException {
        // Incomplete input while typing is normal, so show nothing.
      }
    }
    notifyListeners();
  }

  void _fail(String message) {
    _message = message;
    _refresh();
  }

  void _startNewNumberIfNeeded() {
    if (_justEvaluated) {
      _expression = '';
      _justEvaluated = false;
    }
  }

  // ---- button actions ------------------------------------------------------

  void inputDigit(String digit) {
    _message = null;
    _startNewNumberIfNeeded();
    if (_expression.length >= _maxLength) return _fail('Input is too long');
    if (_lastChar == '%') return _fail('Enter an operator after %');
    if (_lastNumber == '0') {
      _expression = _expression.substring(0, _expression.length - 1); // no "007"
    }
    _expression += digit;
    _refresh();
  }

  void inputDecimal() {
    _message = null;
    _startNewNumberIfNeeded();
    if (_expression.length >= _maxLength) return _fail('Input is too long');
    if (_lastChar == '%') return _fail('Enter an operator after %');
    final number = _lastNumber;
    if (number.contains('.')) return _fail('Invalid decimal input');
    _expression += number.isEmpty ? '0.' : '.';
    _refresh();
  }

  void inputOperator(String op) {
    _message = null;
    if (_expression.isEmpty) {
      if (op == '−') {
        _expression = '−'; // allow a negative first number
        return _refresh();
      }
      return _fail('Enter a number first');
    }
    if (_expression == '−') return _fail('Enter a number first');
    _justEvaluated = false; // continue calculating from the last result
    if (CalculatorEngine.isOperator(_lastChar)) {
      // Multiple operators in a row: the new one replaces the old one.
      var base = _expression.substring(0, _expression.length - 1);
      if (base.isNotEmpty && CalculatorEngine.isOperator(base[base.length - 1])) {
        base = base.substring(0, base.length - 1);
      }
      _expression = base + op;
    } else {
      if (_expression.length >= _maxLength) return _fail('Input is too long');
      _expression += op;
    }
    _refresh();
  }

  void inputPercent() {
    _message = null;
    final last = _lastChar;
    if (last.isEmpty || !(CalculatorEngine.isNumberChar(last) || last == '%')) {
      return _fail('Enter a number before %');
    }
    if (last == '.') return _fail('Invalid decimal input');
    _justEvaluated = false;
    _expression += '%';
    _refresh();
  }

  /// Flips the sign of the number being typed (the +/- button).
  void toggleSign() {
    _message = null;
    if (_lastChar.isEmpty || !CalculatorEngine.isNumberChar(_lastChar)) {
      return _fail('Enter a number first');
    }
    final start = _expression.length - _lastNumber.length;
    final before = start > 0 ? _expression[start - 1] : '';
    final beforeThat = start > 1 ? _expression[start - 2] : '';
    if (before == '−' && (start == 1 || CalculatorEngine.isOperator(beforeThat))) {
      _expression = _expression.replaceRange(start - 1, start, ''); // remove unary −
    } else if (before == '−') {
      _expression = _expression.replaceRange(start - 1, start, '+'); // 5−3 -> 5+3
    } else if (before == '+') {
      _expression = _expression.replaceRange(start - 1, start, '−'); // 5+3 -> 5−3
    } else {
      _expression = _expression.replaceRange(start, start, '−'); // 5 -> −5, 5×3 -> 5×−3
    }
    _refresh();
  }

  void backspace() {
    _message = null;
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _justEvaluated = false;
    }
    _refresh();
  }

  void clear() {
    _expression = '';
    _message = null;
    _justEvaluated = false;
    _refresh();
  }

  void equals() {
    _message = null;
    if (_expression.isEmpty) return _fail('Nothing to calculate');
    if (_justEvaluated) return _refresh(); // already showing the result
    try {
      final result = _engine.format(_engine.evaluate(_expression));
      _history.add(HistoryItem(
        expression: _engine.prettify(_expression),
        result: result,
      ));
      if (result.contains('e')) {
        _expression = ''; // exponent notation cannot be edited further
        _message = 'Result: $result';
      } else {
        _expression = result.replaceAll('-', '−');
        _justEvaluated = true;
      }
    } on CalcException catch (e) {
      _message = e.message; // keep the expression so the user can fix it
    }
    _refresh();
  }

  /// Loads a history result back into the display.
  void useResult(HistoryItem item) {
    _expression = item.result.replaceAll('-', '−');
    _message = null;
    _justEvaluated = false;
    _refresh();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
