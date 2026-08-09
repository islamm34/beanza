import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beanza/app/app.dart';

class _TestHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _TestHttpOverrides();

  testWidgets('App instantiation test', (WidgetTester tester) async {
    const app = CaffeineLiveApp();
    expect(app, isA<StatelessWidget>());
  });
}
