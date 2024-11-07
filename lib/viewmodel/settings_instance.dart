import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/background_subject_code.dart';
import '../model/enum/background_image_option.dart';
import '../model/news_background_subject_type.dart';
import '../model/school_year.dart';
import 'base_view_model.dart';

class SettingsInstance extends ChangeNotifier with BaseViewModel {
  @override
  Future<void> initializing() async {}

  /// News background duration (in minutes).
  int get newsBackgroundDuration => _newsBackgroundDuration;
  set newsBackgroundDuration(int value) {
    if (value < 0) {
      return;
    }

    if (value < 5) {
      value = 5;
    }

    _newsBackgroundDuration = value;
    notifyListeners();
  }
  int _newsBackgroundDuration = 0;


  /// Is global news notify you?
  ///
  /// Since v2.0-draft17
  bool get newsBackgroundGlobalEnabled => _newsBackgroundGlobalEnabled;
  set newsBackgroundGlobalEnabled(bool value) {
    _newsBackgroundGlobalEnabled = value;
    notifyListeners();
  }
  bool _newsBackgroundGlobalEnabled = true;

  /// Is subject news notify you?
  ///
  /// Related: [newsBackgroundFilterList]
  /// Since v2.0-draft17
  NewsBackgroundSubjectType get newsBackgroundSubjectEnabled => _newsBackgroundSubjectEnabled;
  set newsBackgroundSubjectEnabled(NewsBackgroundSubjectType value) {
    _newsBackgroundSubjectEnabled = value;
    notifyListeners();
  }
  NewsBackgroundSubjectType _newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.allNews;

  ///
  List<BackgroundSubjectCode> newsBackgroundFilterList = [];

  ///
  bool get newsBackgroundParseNewsSubject => _newsBackgroundParseNewsSubject;
  set newsBackgroundParseNewsSubject(bool value) {
    _newsBackgroundParseNewsSubject = value;
    notifyListeners();
  }
  bool _newsBackgroundParseNewsSubject = false;

  /// Enable or disable app dark theme.
  ThemeMode themeMode = ThemeMode.system;

  /// Follow color from
  bool accentColor = false;

  /// Set background image option.
  BackgroundImageOption get backgroundImageOption => _backgroundImageOption;
  set backgroundImageOption(BackgroundImageOption value) {
    _backgroundImageOption = value;
    notifyListeners();
  }
  BackgroundImageOption _backgroundImageOption = BackgroundImageOption.none;

  /// Make app background to black color. Only in dark mode.
  /// This won't work if [backgroundImageOption] is different than `none`.
  bool get blackBackground => _blackBackground;
  set blackBackground(bool value) {
    _blackBackground = value;
    notifyListeners();
  }
  bool _blackBackground = false;

  ///
  double backgroundImageOpacity = 0.65;

  ///
  double componentOpacity = 0.65;

  // Miscellaneous
  /// Automatically find locale and set language from that.
  bool get localeAuto => _localeAuto;
  set localeAuto(bool value) {
    _localeAuto = value;
    notifyListeners();
  }
  bool _localeAuto = true;

  /// Set locale manually.
  Locale get locale => _locale;
  set locale(Locale lo) {
    _locale = lo;
    notifyListeners();
  }
  Locale _locale = Locale("en");

  /// Adjust school year. This will affect almost functions in `Accounts` screen.
  SchoolYear get currentSchoolYear => _currentSchoolYear;
  set currentSchoolYear(SchoolYear value) {
    _currentSchoolYear = value;
    notifyListeners();
  }
  SchoolYear _currentSchoolYear = SchoolYear(year: 24, semester: 1);

  /// Open all links inside app. Disable to open these on external browser.
  bool get openLinkInsideApp => _openLinkInsideApp;
  set openLinkInsideApp(bool value) {
    _openLinkInsideApp = value;
    notifyListeners();
  }
  bool _openLinkInsideApp = true;

  /// Is news opened in bottom sheet?
  ///
  /// * `true`: News will open in bottom sheet.
  /// * `false`: News will open in new activity.
  ///
  /// Since v2.0-draft19
  bool openNewsInModalBottomSheet = true;

  Map<String, dynamic> toMap() {
    return {
      "appsettings.locale.auto": localeAuto,
      "appsettings.locale.specificed": locale.toLanguageTag(),
      "appsettings.appearance.thememode": themeMode == ThemeMode.system
          ? 0
          : themeMode == ThemeMode.dark
              ? 1
              : 2,
      "appsettings.appearance.dynamiccolor": accentColor,
      "appsettings.appearance.blackbackground": blackBackground,
      "appsettings.appearance.backgroundimage.option": backgroundImageOption.value,
      "appsettings.appearance.backgroundimage.backgroundopacity": backgroundImageOpacity,
      "appsettings.appearance.backgroundimage.componentopacity": componentOpacity,
      "appsettings.miscellaneous.openlinkinsideapp": openLinkInsideApp,
      "appsettings.newsbackground.duration": newsBackgroundDuration,
      "appsettings.newsbackground.filterlist": newsBackgroundFilterList,
      "appsettings.newsbackground.newsglobal.enabled": newsBackgroundGlobalEnabled,
      "appsettings.newsbackground.newssubject.enabled": newsBackgroundSubjectEnabled.value,
      "appsettings.newsbackground.parsenewssubject": newsBackgroundParseNewsSubject,
      "appsettings.globalvariables.schoolyear": currentSchoolYear,
      "appsettings.behavor.clicknewsinmain": openNewsInModalBottomSheet,
    };
  }

  String toJson() => json.encode(toMap());
}
