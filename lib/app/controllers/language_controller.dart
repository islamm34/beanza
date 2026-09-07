import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String storageKey = 'app_language_code';
  static const String englishCode = 'en';
  static const String arabicCode = 'ar';

  SharedPreferences? _prefs;
  final Rx<Locale> _currentLocale = const Locale(englishCode).obs;

  LanguageController({SharedPreferences? prefs}) : _prefs = prefs {
    if (prefs != null) {
      _loadFromPrefs(prefs);
    }
  }

  Locale get currentLocale => _currentLocale.value;
  String get selectedLanguageCode => _currentLocale.value.languageCode;
  String get currentLanguage => _currentLocale.value.languageCode;
  bool get isArabic => _currentLocale.value.languageCode == arabicCode;
  bool get isEnglish => _currentLocale.value.languageCode == englishCode;
  bool get isRtl => isArabic;
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  @override
  void onInit() {
    super.onInit();
    if (_prefs == null) {
      _loadPersistedLanguage();
    }
  }

  void _loadFromPrefs(SharedPreferences prefs) {
    final savedCode = prefs.getString(storageKey);
    if (savedCode != null &&
        (savedCode == arabicCode || savedCode == englishCode)) {
      _currentLocale.value = savedCode == arabicCode
          ? const Locale(arabicCode, 'EG')
          : const Locale(englishCode, 'US');
    } else {
      _currentLocale.value = const Locale(englishCode, 'US');
    }
  }

  Future<void> _loadPersistedLanguage() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _loadFromPrefs(_prefs!);
    } catch (_) {
      _currentLocale.value = const Locale(englishCode, 'US');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    final code =
        languageCode.toLowerCase() == arabicCode ? arabicCode : englishCode;
    final locale = code == arabicCode
        ? const Locale(arabicCode, 'EG')
        : const Locale(englishCode, 'US');

    _currentLocale.value = locale;
    Get.locale = locale;
    if (Get.context != null) {
      try {
        await Get.updateLocale(locale);
      } catch (_) {}
    }

    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs?.setString(storageKey, code);
    } catch (_) {}
  }

  Future<void> toggleLanguage() async {
    await changeLanguage(isArabic ? englishCode : arabicCode);
  }

  String getLanguageDisplayName(String languageCode) {
    if (languageCode == arabicCode) {
      return 'العربية';
    }
    return 'English';
  }
}
