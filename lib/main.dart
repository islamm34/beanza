import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized before accessing plugins
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve native splash screen until Flutter splash is ready
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Set preferred orientations for consistent layout
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: CaffeineLiveApp(),
    ),
  );
}
