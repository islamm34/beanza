import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beanza/core/widgets/common/adaptive_cafe_logo.dart';

void main() {
  testWidgets('AdaptiveCafeLogo renders correctly in Light Mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: const Scaffold(
          body: Center(
            child: AdaptiveCafeLogo(size: 120),
          ),
        ),
      ),
    );

    expect(find.byType(AdaptiveCafeLogo), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);

    final animatedContainer =
        tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = animatedContainer.decoration as BoxDecoration?;
    expect(decoration, isNotNull);
    expect(decoration?.color, Colors.transparent);
    expect(decoration?.boxShadow, isNotEmpty);
  });

  testWidgets('AdaptiveCafeLogo renders correctly in Dark Mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const Scaffold(
          body: Center(
            child: AdaptiveCafeLogo(size: 120),
          ),
        ),
      ),
    );

    expect(find.byType(AdaptiveCafeLogo), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);

    final animatedContainer =
        tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = animatedContainer.decoration as BoxDecoration?;
    expect(decoration, isNotNull);
    expect(decoration?.color, isNot(Colors.transparent));
    expect(decoration?.boxShadow, isNotEmpty);
  });

  testWidgets('buildAdaptiveCafeLogo helper builds AdaptiveCafeLogo widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                buildAdaptiveCafeLogo(context: context, size: 100),
          ),
        ),
      ),
    );

    expect(find.byType(AdaptiveCafeLogo), findsOneWidget);
  });
}
