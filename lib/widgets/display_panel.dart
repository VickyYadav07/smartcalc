import 'package:flutter/material.dart';

import '../services/calculator_controller.dart';

/// Large display: current expression on top, message / preview underneath.
class DisplayPanel extends StatelessWidget {
  const DisplayPanel({super.key, required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final expression = controller.displayExpression;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(28),
          ),
          // Font sizes follow the available height so it fits any screen.
          child: LayoutBuilder(builder: (context, constraints) {
            final mainSize = (constraints.maxHeight * 0.42).clamp(28.0, 64.0);
            final subSize = (constraints.maxHeight * 0.15).clamp(12.0, 20.0);
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    expression.isEmpty ? '0' : expression,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: mainSize,
                      fontWeight: FontWeight.w300,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.subLine.isEmpty ? '\u00A0' : controller.subLine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: subSize,
                    color: controller.hasMessage
                        ? scheme.error
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
