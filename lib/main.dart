import 'package:flutter/material.dart';

import 'screens/calculator_screen.dart';

void main() => runApp(const SmartCalcApp());

/// Root widget: sets up the Material 3 theme (light + dark) and the home screen.
class SmartCalcApp extends StatelessWidget {
  const SmartCalcApp({super.key});

  ThemeData _theme(Brightness brightness) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: brightness,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartCalc',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: ThemeMode.system, // follows the device setting
      home: const CalculatorScreen(),
    );
  }
}
