// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cs467_language_learning_app/main.dart';

void main() {
  testWidgets('Verify that Home page is set up correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our username field displays Username.
    expect(find.text('Username'), findsOneWidget);
    // Verify that our password field displays Username.
    expect(find.text('Password'), findsOneWidget);

    // Verify that there is a login button.
    expect(find.text('Login'), findsOneWidget);

    // Verify that there is a sign up button.
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
