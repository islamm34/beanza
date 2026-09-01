import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/core/widgets/inputs/search_field.dart';

void main() {
  group('SearchField Widget', () {
    testWidgets('renders hint text and search icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchField(
              hintText: 'Search coffee...',
            ),
          ),
        ),
      );

      expect(find.text('Search coffee...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('triggers onChanged callback when typing',
        (WidgetTester tester) async {
      String searchQuery = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField(
              hintText: 'Search',
              onChanged: (value) {
                searchQuery = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Espresso');
      expect(searchQuery, 'Espresso');
    });
  });
}
