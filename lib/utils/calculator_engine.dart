/// Error with a user-friendly message (shown directly in the UI).
class CalcException implements Exception {
  const CalcException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Pure calculation logic (no Flutter code), so it is easy to unit test.
///
/// Grammar (lowest to highest precedence):
///   expression := term (('+' | '−') term)*
///   term       := unary (('×' | '÷') unary)*
///   unary      := '−' unary | number '%'*
/// `%` means "divide by 100" (50% = 0.5), so × and ÷ bind tighter than + and −.
class CalculatorEngine {
  static const List<String> operators = ['+', '−', '×', '÷'];

  static bool isOperator(String c) => operators.contains(c);

  static bool isNumberChar(String c) {
    final code = c.codeUnitAt(0);
    return (code >= 48 && code <= 57) || c == '.'; // 0-9 or '.'
  }

  /// Evaluates [expression]; throws [CalcException] when it is invalid.
  double evaluate(String expression) {
    if (expression.trim().isEmpty) {
      throw const CalcException('Nothing to calculate');
    }
    final value = _Parser(_tokenize(expression)).parse();
    if (value.isNaN || value.isInfinite) {
      throw const CalcException('Result is too large');
    }
    return value;
  }

  /// Rounds away floating-point noise (0.1 + 0.2 -> 0.3) and drops ".0".
  String format(double value) {
    final rounded = double.parse(value.toStringAsPrecision(12));
    if (rounded == 0) return '0';
    if (rounded.abs() >= 1e15 || rounded.abs() < 1e-9) {
      return rounded.toStringAsExponential(6);
    }
    if (rounded == rounded.truncateToDouble()) return rounded.toInt().toString();
    final text = rounded.toString();
    if (!text.contains('e')) return text;
    // Very small numbers: avoid Dart's "1e-7" style.
    return rounded.toStringAsFixed(12).replaceFirst(RegExp(r'0+$'), '');
  }

  /// Adds spaces around binary operators: "2+3×4" -> "2 + 3 × 4".
  String prettify(String expression) {
    final buffer = StringBuffer();
    for (var i = 0; i < expression.length; i++) {
      final c = expression[i];
      final afterValue =
          i > 0 && (isNumberChar(expression[i - 1]) || expression[i - 1] == '%');
      buffer.write(isOperator(c) && afterValue ? ' $c ' : c);
    }
    return buffer.toString().trimRight();
  }

  /// Splits the text into numbers (double) and symbols (String).
  List<Object> _tokenize(String text) {
    final tokens = <Object>[];
    var i = 0;
    while (i < text.length) {
      final c = text[i];
      if (isNumberChar(c)) {
        var j = i;
        var dots = 0;
        while (j < text.length && isNumberChar(text[j])) {
          if (text[j] == '.') dots++;
          j++;
        }
        var number = text.substring(i, j);
        if (dots > 1 || number == '.') {
          throw const CalcException('Invalid decimal input');
        }
        if (number.startsWith('.')) number = '0$number';
        if (number.endsWith('.')) number = '${number}0';
        tokens.add(double.parse(number));
        i = j;
      } else if (isOperator(c) || c == '%') {
        tokens.add(c);
        i++;
      } else {
        throw const CalcException('Invalid calculation');
      }
    }
    return tokens;
  }
}

/// Recursive-descent parser that evaluates while parsing.
class _Parser {
  _Parser(this._tokens);

  final List<Object> _tokens;
  int _pos = 0;

  double parse() {
    final value = _expression();
    if (_pos < _tokens.length) throw const CalcException('Invalid calculation');
    return value;
  }

  bool _peekIs(String symbol) => _pos < _tokens.length && _tokens[_pos] == symbol;

  double _expression() {
    var value = _term();
    while (_peekIs('+') || _peekIs('−')) {
      final op = _tokens[_pos++];
      final right = _term();
      value = op == '+' ? value + right : value - right;
    }
    return value;
  }

  double _term() {
    var value = _unary();
    while (_peekIs('×') || _peekIs('÷')) {
      final op = _tokens[_pos++];
      final right = _unary();
      if (op == '×') {
        value *= right;
      } else {
        if (right == 0) throw const CalcException('Cannot divide by zero');
        value /= right;
      }
    }
    return value;
  }

  double _unary() {
    if (_peekIs('−')) {
      _pos++;
      return -_unary();
    }
    if (_pos >= _tokens.length) throw const CalcException('Incomplete expression');
    final token = _tokens[_pos];
    if (token is! double) throw const CalcException('Invalid calculation');
    _pos++;
    var value = token;
    while (_peekIs('%')) {
      _pos++;
      value /= 100;
    }
    return value;
  }
}
