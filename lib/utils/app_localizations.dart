import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  Future<bool> load() async {
    Map<String, dynamic> jsonMapEn = json.decode(await rootBundle.loadString('assets/lang/en.json'));
    Map<String, dynamic> jsonMapLocale = {};

    if (await File('assets/lang/${locale.languageCode}.json').exists()) {
      jsonMapLocale = json.decode(await rootBundle.loadString('assets/lang/${locale.languageCode}.json'));
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
