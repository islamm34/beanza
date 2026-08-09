import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/core/widgets/buttons/primary_button.dart';

void main() {
  group('PrimaryButton Widget', () {
    testWidgets('renders button label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Checkout Now',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Checkout Now'), findsOneWidget);
    });

    testWidgets('triggers onPressed callback when tapped', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Tap Me',
              onPressed: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      expect(wasTapped, isTrue);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Processing',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing'), findsNothing);
    });
  });
}
