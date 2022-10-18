// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cs467_language_learning_app/main.dart';
import 'package:cs467_language_learning_app/screens/create_account_screen.dart';
import 'package:cs467_language_learning_app/screens/home_login_screen.dart';

import 'package:mocktail/mocktail.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  Widget createHomeWidgetUnderTest() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      home: const HomeLoginScreen(title: 'Learning App Login'),
    );
  }

  Widget createSignUpWidgetUnderTest() {
    return MaterialApp(
      home: CreateAccountScreen(),
    );
  }

  testWidgets('Verify that Home page is set up correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(createHomeWidgetUnderTest());

    // Verify that our email field displays 'Email'.
    expect(find.text('Email'), findsOneWidget);
    // Verify that our password field displays 'Password'.
    expect(find.text('Password'), findsOneWidget);

    // Verify that there is a login button.
    expect(find.text('Login'), findsOneWidget);

    // Verify that there is a sign up button.
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('Verify that Tapping Sign Up Button navigates to Sign Up page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createHomeWidgetUnderTest());
    await tester.pump();
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeLoginScreen), findsNothing);
    expect(find.byType(CreateAccountScreen), findsOneWidget);
    expect(find.text('Create your account'), findsOneWidget);
  });

  testWidgets('Verify that the Sign Up page is set up correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createSignUpWidgetUnderTest());
    // Verify that our email field displays 'Email'.
    expect(find.text('Email'), findsOneWidget);
    // Verify that our password field displays 'Password'.
    expect(find.text('Password'), findsOneWidget);
    // Verify that our confirm password field displays 'Confirm Password'.
    expect(find.text('Confirm Password'), findsOneWidget);

    // Verify that there is a sign up button.
    expect(find.text('Create your account'), findsOneWidget);
  });

  testWidgets('Verify that Tapping Cancel Button navigates back to Home page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createHomeWidgetUnderTest());
    await tester.pump();
    await tester.tap(find.text('Sign Up'));
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(CreateAccountScreen), findsNothing);
    expect(find.byType(HomeLoginScreen), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
