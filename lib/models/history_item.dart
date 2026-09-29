/// One finished calculation shown in the history list.
class HistoryItem {
  const HistoryItem({required this.expression, required this.result});

  /// Formatted expression, e.g. "25 + 15".
  final String expression;

  /// Formatted result, e.g. "40".
  final String result;

  /// Text shown in the history list, e.g. "25 + 15 = 40".
  String get text => '$expression = $result';
}
