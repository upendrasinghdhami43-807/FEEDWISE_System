import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feedwise_mobile/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('FeedWise app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FeedWiseApp()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
