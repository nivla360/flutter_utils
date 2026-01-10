import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('Flutter Utils Example App loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutterUtilsExampleApp());

    // Verify that our app loads correctly
    expect(find.text('Flutter Utils Examples'), findsOneWidget);
  });
}