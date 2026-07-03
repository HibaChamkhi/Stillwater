import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stillwater/core/di/injection.dart';
import 'package:stillwater/main.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('Launches on Today with bottom navigation', (tester) async {
    await tester.pumpWidget(const StillwaterApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('gentle'), findsWidgets);
    expect(find.text('Today'), findsWidgets);
    expect(find.text('Breathe'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Journal'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
  });

  testWidgets('Library filter narrows the visible list', (tester) async {
    await tester.pumpWidget(const StillwaterApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    expect(find.text('A slow walk'), findsOneWidget);

    await tester.tap(find.text('Walks'));
    await tester.pumpAndSettle();
    expect(find.text('A slow walk'), findsOneWidget);
    expect(find.text('Morning tea, alone'), findsNothing);
  });

  testWidgets('Saving a journal entry confirms it', (tester) async {
    await tester.pumpWidget(const StillwaterApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'A quiet morning.');
    await tester.tap(find.text('Save this page'));
    await tester.pump();

    expect(find.text("Saved to today's pages."), findsOneWidget);
  });
}
