import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:synaptiq/main.dart';

void main() {
  testWidgets('App renders without crash', (WidgetTester tester) async {
    await tester.pumpWidget(const SynaptiqApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
