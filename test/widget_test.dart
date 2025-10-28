// import 'package:calculator_app/app.dart';
// import 'package:calculator_app/features/settings/logic/settings_provider.dart';
// import 'package:calculator_app/features/history/logic/history_provider.dart';
// import 'package:calculator_app/features/calculator/logic/calculator_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Create the providers like in main.dart
//     final settingsProvider = SettingsProvider();
//     final historyProvider = HistoryProvider();
//     final calculatorProvider = CalculatorProvider(historyProvider);

//     // Build app with providers
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => settingsProvider),
//           ChangeNotifierProvider(create: (_) => historyProvider),
//           ChangeNotifierProvider(create: (_) => calculatorProvider),
//         ],
//         child: const CalculatorApp(),
//       ),
//     );

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
