import 'package:flutter/material.dart';

import '../services/calculator_controller.dart';
import '../widgets/display_panel.dart';
import '../widgets/history_panel.dart';
import '../widgets/keypad.dart';

/// Main screen. Phones: calculator + history bottom sheet.
/// Tablets / wide windows (>= 720 dp): calculator and history side by side.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  static const double _wideBreakpoint = 720;

  final CalculatorController _controller = CalculatorController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showHistorySheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SizedBox(
        height: MediaQuery.sizeOf(sheetContext).height * 0.6,
        child: HistoryPanel(
          controller: _controller,
          onSelected: () => Navigator.of(sheetContext).pop(),
        ),
      ),
    );
  }

  Widget _calculator() => Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(flex: 2, child: DisplayPanel(controller: _controller)),
            const SizedBox(height: 8),
            Expanded(flex: 5, child: Keypad(controller: _controller)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartCalc',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (!isWide)
            IconButton(
              tooltip: 'History',
              icon: const Icon(Icons.history),
              onPressed: _showHistorySheet,
            ),
        ],
      ),
      body: SafeArea(
        child: isWide
            ? Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: _calculator(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: HistoryPanel(controller: _controller),
                      ),
                    ),
                  ),
                ],
              )
            : _calculator(),
      ),
    );
  }
}
