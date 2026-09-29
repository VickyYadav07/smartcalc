import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Visual style groups so numbers, operators and functions look different.
enum CalcButtonType { number, function, operator, equals }

/// A single rounded calculator key that scales with the space it is given.
class CalcButton extends StatelessWidget {
  const CalcButton({
    super.key,
    required this.label,
    required this.type,
    required this.onPressed,
    this.semanticLabel,
  });

  final String label;
  final CalcButtonType type;
  final VoidCallback onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color background, Color foreground) = switch (type) {
      CalcButtonType.number => (scheme.surfaceContainerHighest, scheme.onSurface),
      CalcButtonType.function =>
        (scheme.secondaryContainer, scheme.onSecondaryContainer),
      CalcButtonType.operator =>
        (scheme.primaryContainer, scheme.onPrimaryContainer),
      CalcButtonType.equals => (scheme.primary, scheme.onPrimary),
    };

    return Padding(
      padding: const EdgeInsets.all(5),
      child: LayoutBuilder(builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        return Semantics(
          button: true,
          label: semanticLabel ?? label,
          excludeSemantics: true,
          child: Material(
            color: background,
            borderRadius: BorderRadius.circular(size * 0.32),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: (size * 0.38).clamp(18.0, 40.0),
                    fontWeight: FontWeight.w500,
                    color: foreground,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
