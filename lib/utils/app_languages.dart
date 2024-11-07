import 'dart:ui';

class AppLanguages {
  static final Map<String, String> localeCodeList = {
    'en': 'English',
    'vi': 'Tiếng Việt',
  };

  static String getLocaleDisplayName(Locale locale) {
    return localeCodeList[locale.languageCode] ?? locale.languageCode;
  }
}