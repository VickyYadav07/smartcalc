# SmartCalc

A modern, responsive cross-platform calculator built with **Flutter** and **Dart** using Material Design 3.

## Project Description
SmartCalc is a calculator app with a large display, rounded colour-coded keys, live result preview and a calculation history. The layout adapts automatically: phones show the calculator with a history bottom sheet, tablets and wide windows show the calculator and history side by side. No backend, database, API or internet connection is needed.

## Objective
To demonstrate cross-platform application development by building a clean, well-structured, tested and responsive Flutter application that separates UI code from calculation logic.

## Features
- Addition, subtraction, multiplication, division and percentage (`50%` = 0.5)
- Correct operator precedence (`2 + 3 × 4 = 14`)
- Decimal numbers, clear (AC), backspace (⌫), plus/minus (±) and equals (=)
- Continuous calculations (keep using the previous result)
- Live result preview while typing
- Calculation history (`25 + 15 = 40`); tap an entry to reuse its result; clear all
- Friendly error messages: division by zero, invalid or incomplete input, repeated operators, duplicate decimal points, empty input
- Responsive layout for phones, tablets and different resolutions; light and dark themes

## Technologies Used
Flutter, Dart, Material Design 3, `flutter_test` (unit and widget tests). No third-party packages.

## Software Requirements
- Flutter SDK 3.22 or newer (includes Dart 3.4+)
- Android Studio (Android SDK) or a physical Android phone with USB debugging
- VS Code with the **Flutter** extension (recommended)
- Git

## How to Install Flutter
1. Download the SDK from <https://docs.flutter.dev/get-started/install> for your OS.
2. Extract it (for example `C:\src\flutter`) and add `flutter\bin` to your `PATH`.
3. Install Android Studio and its Android SDK / command-line tools.
4. Run `flutter doctor` and fix anything marked with ✗.
5. Run `flutter doctor --android-licenses` and accept the licenses.

## How to Run the Project
```bash
git clone <your-repository-url>
cd smartcalc
flutter create --platforms=android,ios,web,windows .   # generates platform folders (first time only; keeps lib/ untouched)
flutter pub get
flutter run
```
Run the tests with `flutter test` and build an APK with `flutter build apk --release`
(output: `build/app/outputs/flutter-apk/app-release.apk`).

## Project Structure
```
smartcalc/
├── lib/
│   ├── main.dart                      # App entry point and theme
│   ├── models/history_item.dart       # One history entry
│   ├── screens/calculator_screen.dart # Responsive main screen
│   ├── services/calculator_controller.dart # State + button handling + history
│   ├── utils/calculator_engine.dart   # Expression parser / evaluator / formatting
│   └── widgets/                       # calc_button, keypad, display_panel, history_panel
├── test/                              # Unit and widget tests
├── docs/screenshots/                  # Put screenshots here
├── pubspec.yaml
├── analysis_options.yaml
└── .gitignore
```

## Screenshots
Run the app, take screenshots, save them in `docs/screenshots/` and link them here, for example:

```markdown
![Phone](docs/screenshots/phone.png)
![Tablet](docs/screenshots/tablet.png)
```

## Future Enhancements
- Scientific mode (sin, cos, log, square root, powers)
- Saving history between launches
- Keyboard input on desktop and web
- Theme selector and unit conversion

## Conclusion
SmartCalc shows how Flutter delivers one code base for many platforms, and how separating UI, state and calculation logic keeps a project readable, testable and easy to extend.
