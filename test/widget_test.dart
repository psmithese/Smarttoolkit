// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:smarttoolkit/main.dart';

void main() {
  testWidgets('App renders Home Screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartToolkitApp());

    // Verify that the app title is present
    expect(find.text('Utility Toolkit'), findsOneWidget);

    // Verify that tool cards are present
    expect(find.text('Unit Converter'), findsOneWidget);
    expect(find.text('BMI Calc'), findsOneWidget);
  });
}
