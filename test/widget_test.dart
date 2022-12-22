import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:language_archive/screens/create_account_screen.dart';
import 'package:language_archive/screens/home_login_screen.dart';
import './firebase_mock.dart';

Future<void> main() async {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  Widget createHomeWidgetUnderTest() {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      home: const HomeLoginScreen(),
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
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('Verify that the Sign Up page is set up correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createSignUpWidgetUnderTest());
    // Verify that our name field displays 'Name'.
    expect(find.text('Name'), findsOneWidget);
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
    expect(find.text('Login'), findsOneWidget);
  });
}
