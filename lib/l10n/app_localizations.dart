import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/enum/app_log_level.dart';
import '../utils/app_utils.dart';
import '../utils/string_utils.dart';

class AppLocalizations {
  static final Map<String, String> availableLocaleList = {
    'en': 'English',
    'vi': 'Tiếng Việt',
  };

  static String getLocaleDisplayName(Locale locale) {
    return availableLocaleList[locale.languageCode] ?? locale.languageCode;
  }

  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  Future<bool> load() async {
    Map<String, dynamic> jsonMapEn = json.decode(await rootBundle.loadString('assets/lang/en.json'));
    Map<String, dynamic> jsonMapLocale = {};

    String filePath = 'assets/lang/${locale.languageCode}.json';

    try {
      jsonMapLocale = json.decode(await rootBundle.loadString('assets/lang/${locale.languageCode}.json'));
      AppUtils.showLogToDebug(
        tag: 'Localization',
        resultTag: AppLogLevel.info,
        dateCreated: DateTime.now().toUtc().millisecondsSinceEpoch,
        message: '$filePath loaded with locale (${locale.languageCode}, ${locale.countryCode})',
      );
    } catch (_) {
      // TODO: Exception when not successfully loaded
      AppUtils.showLogToDebug(
        tag: 'Localization',
        resultTag: AppLogLevel.error,
        dateCreated: DateTime.now().toUtc().millisecondsSinceEpoch,
        message: 'Cannot load $filePath. Maybe file not found, or file error?',
      );
      AppUtils.showLogToDebug(
        tag: 'Localization',
        resultTag: AppLogLevel.warning,
        dateCreated: DateTime.now().toUtc().millisecondsSinceEpoch,
        message: 'English will be used instead.',
      );
    }

    // Merging maps using addAll with a check
    jsonMapEn.forEach((key, value) {
      if (!jsonMapLocale.containsKey(key)) {
        jsonMapLocale[key] = value;
      }
    });

    _localizedStrings = jsonMapLocale.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  String translateWithParameters(String key, List<String?> args) {
    var stringBase = _localizedStrings[key] ?? key;
    return StringUtils.formatString(stringBase, args);
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
