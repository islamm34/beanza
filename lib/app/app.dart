import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'bindings/initial_binding.dart';
import 'controllers/language_controller.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';
import 'translations/app_translations.dart';

class CaffeineLiveApp extends StatelessWidget {
  const CaffeineLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController(), permanent: true);

    return GetMaterialApp(
      title: 'Brewora',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: languageController.currentLocale,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
