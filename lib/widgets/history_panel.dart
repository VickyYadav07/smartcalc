import 'package:flutter/material.dart';

import '../services/calculator_controller.dart';

/// List of previous calculations with a "Clear" button.
/// Tapping an entry loads its result back into the calculator.
class HistoryPanel extends StatelessWidget {
  const HistoryPanel({super.key, required this.controller, this.onSelected});

  final CalculatorController controller;

  /// Called after an entry is tapped (e.g. to close a bottom sheet).
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final items = controller.history;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
              child: Row(
                children: [
                  Text('History', style: textTheme.titleLarge),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: items.isEmpty ? null : controller.clearHistory,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text('No calculations yet',
                          style: textTheme.bodyLarge),
                    )
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        // Newest calculation first.
                        final item = items[items.length - 1 - index];
                        return ListTile(
                          title: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(item.text,
                                  style: textTheme.titleMedium),
                            ),
                          ),
                          onTap: () {
                            controller.useResult(item);
                            onSelected?.call();
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
