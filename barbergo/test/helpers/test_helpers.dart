/// Helper utilities for testing
///
/// This file contains common utilities used across all tests in the project.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a test widget wrapped with ProviderScope for Riverpod testing
Widget createTestWidget({required Widget child, List<Override>? overrides}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(home: child),
  );
}

/// Creates a ProviderContainer for testing providers directly
ProviderContainer createContainer({List<Override>? overrides, ProviderContainer? parent}) {
  final container = ProviderContainer(overrides: overrides ?? [], parent: parent);

  // Automatically dispose the container when the test is done
  addTearDown(container.dispose);

  return container;
}

/// Pumps the widget and waits for all frames to settle
Future<void> pumpAndSettleWithDelay(WidgetTester tester, {Duration delay = const Duration(milliseconds: 100)}) async {
  await tester.pumpAndSettle();
  await Future.delayed(delay);
  await tester.pumpAndSettle();
}

/// Finds a widget by its exact text content
Finder findTextExact(String text) {
  return find.text(text);
}

/// Finds a widget containing partial text
Finder findTextContaining(String text) {
  return find.byWidgetPredicate((widget) => widget is Text && widget.data != null && widget.data!.contains(text));
}

/// Simulates a tap and waits for animations
Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Enters text into a TextField and settles
Future<void> enterTextAndSettle(WidgetTester tester, Finder finder, String text) async {
  await tester.enterText(finder, text);
  await tester.pumpAndSettle();
}

/// Verifies that a widget is visible on screen
void expectVisible(Finder finder) {
  expect(finder, findsOneWidget);
}

/// Verifies that a widget is not visible on screen
void expectNotVisible(Finder finder) {
  expect(finder, findsNothing);
}

/// Verifies that multiple widgets are visible
void expectMultiple(Finder finder, int count) {
  expect(finder, findsNWidgets(count));
}
