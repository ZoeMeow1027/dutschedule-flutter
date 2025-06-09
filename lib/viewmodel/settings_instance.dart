import 'package:flutter/material.dart';

import '../model/background_subject_code.dart';
import '../model/enum/app_theme_mode.dart';
import '../model/enum/background_image_option.dart';
import '../model/news_background_subject_type.dart';
import '../model/school_year.dart';
import '../repository/storage_repository.dart';
import '../utils/app_utils.dart';
import 'base_view_model.dart';

class SettingsInstance extends BaseViewModel {
  SettingsInstance();

  SettingsInstance.fromPreviousSettings(Map<String, dynamic> json) {
    _fromMap(json);
    _isSettingsInitialized = true;
  }

  @override
  void initializing() async {}

  bool _isSettingsInitialized = false;

  @override
  void timerAction() {}

  /// First run (show welcome page)
  ///
  /// **Settings name:** appbehavior.firstrun.done
  bool get firstRunDone => _firstRunDone;

  set firstRunDone(bool value) {
    if (value == _firstRunDone) {
      return;
    }

    _firstRunDone = value;
    _settingsChanged();
  }

  bool _firstRunDone = false;

  /// News background timeout duration (in minutes, must be larger than 5).
  /// Set to 0 to disable this function.
  ///
  /// **Settings name:** appsettings.newsbackground.duration
  int get newsBackgroundDuration => _newsBackgroundDuration;

  set newsBackgroundDuration(int value) {
    if (value < 0) {
      return;
    }

    if (value != 0) {
      if (value < 5) {
        value = 5;
      }
    }

    _newsBackgroundDuration = value;
    _settingsChanged();
  }

  int _newsBackgroundDuration = 0;

  /// Enable or disable news background notification for global news
  ///
  /// **Settings name:** appsettings.newsbackground.newsglobal.enabled
  /// **Since:** v2.0-draft17
  bool get newsBackgroundGlobalEnabled => _newsBackgroundGlobalEnabled;

  set newsBackgroundGlobalEnabled(bool value) {
    if (value == _newsBackgroundGlobalEnabled) {
      return;
    }

    _newsBackgroundGlobalEnabled = value;
    _settingsChanged();
  }

  bool _newsBackgroundGlobalEnabled = true;

  /// Enable or disable news background notification for sutduent affairs news
  ///
  /// **Settings name:** appsettings.newsbackground.studentaffairs.enabled
  /// **Since:** v2.5.5-250506
  bool get newsBackgroundStudentAffairsEnabled => _newsBackgroundStudentAffairsEnabled;

  set newsBackgroundStudentAffairsEnabled(bool value) {
    if (value == _newsBackgroundStudentAffairsEnabled) {
      return;
    }

    _newsBackgroundStudentAffairsEnabled = value;
    _settingsChanged();
  }

  bool _newsBackgroundStudentAffairsEnabled = true;

  /// Enable or disable news background notification for examination news
  ///
  /// **Settings name:** appsettings.newsbackground.examination.enabled
  /// **Since:** v2.5.5-250506
  bool get newsBackgroundExaminationEnabled => _newsBackgroundExaminationEnabled;

  set newsBackgroundExaminationEnabled(bool value) {
    if (value == _newsBackgroundExaminationEnabled) {
      return;
    }

    _newsBackgroundExaminationEnabled = value;
    _settingsChanged();
  }

  bool _newsBackgroundExaminationEnabled = true;

  /// Enable or disable news background notification for tuition fee news
  ///
  /// **Settings name:** appsettings.newsbackground.tuitionfee.enabled
  /// **Since:** v2.0-draft17
  bool get newsBackgroundTuitionFeeEnabled => _newsBackgroundTuitionFeeEnabled;

  set newsBackgroundTuitionFeeEnabled(bool value) {
    if (value == _newsBackgroundTuitionFeeEnabled) {
      return;
    }

    _newsBackgroundTuitionFeeEnabled = value;
    _settingsChanged();
  }

  bool _newsBackgroundTuitionFeeEnabled = true;

  /// Is subject news notify you?
  ///
  /// **Related:** [newsBackgroundFilterList]
  /// **Settings name:** appsettings.newsbackground.newssubject.enabled
  /// **Since:** v2.0-draft17
  NewsBackgroundSubjectType get newsBackgroundSubjectEnabled => _newsBackgroundSubjectEnabled;

  set newsBackgroundSubjectEnabled(NewsBackgroundSubjectType value) {
    if (value == _newsBackgroundSubjectEnabled) {
      return;
    }

    _newsBackgroundSubjectEnabled = value;
    _settingsChanged();
  }

  NewsBackgroundSubjectType _newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.allNews;

  ///
  ///
  /// **Settings name:** appsettings.newsbackground.filterlist
  List<BackgroundSubjectCode> newsBackgroundFilterList = [
    BackgroundSubjectCode(studentYearId: "18", classId: "12", subjectName: "Subject 1"),
    BackgroundSubjectCode(studentYearId: "19", classId: "12", subjectName: "Subject 2"),
    BackgroundSubjectCode(studentYearId: "20", classId: "12", subjectName: "Subject 3"),
    BackgroundSubjectCode(studentYearId: "21", classId: "12", subjectName: "Subject 4"),
    BackgroundSubjectCode(studentYearId: "17", classId: "12", subjectName: "Subject 5"),
  ];

  void addNewsBackgroundFilter(BackgroundSubjectCode filter) {
    newsBackgroundFilterList.add(filter);
    _settingsChanged();
  }

  void removeNewsBackgroundFilter(BackgroundSubjectCode filter) {
    newsBackgroundFilterList.remove(filter);
    _settingsChanged();
  }

  void removeAllNewsBackgroundFilters() {
    newsBackgroundFilterList.clear();
    _settingsChanged();
  }

  ///
  ///
  /// **Settings name:** appsettings.newsbackground.newssubject.parsenotification
  bool get newsBackgroundParseNewsSubject => _newsBackgroundParseNewsSubject;

  set newsBackgroundParseNewsSubject(bool value) {
    if (value == _newsBackgroundParseNewsSubject) {
      return;
    }

    _newsBackgroundParseNewsSubject = value;
    _settingsChanged();
  }

  bool _newsBackgroundParseNewsSubject = false;

  /// Enable or disable app dark theme.
  ///
  /// **Settings name:** appsettings.appearance.thememode
  AppThemeMode get themeMode => _themeMode;

  set themeMode(AppThemeMode value) {
    if (value == _themeMode) {
      return;
    }

    _themeMode = value;
    _settingsChanged();
  }

  AppThemeMode _themeMode = AppThemeMode.followSystemSettings;

  /// Follow accent color from system
  ///
  /// **Settings name:** appsettings.appearance.dynamiccolor
  bool get followAccentColor => _followAccentColor;

  set followAccentColor(bool value) {
    if (value == _followAccentColor) {
      return;
    }

    _followAccentColor = value;
    _settingsChanged();
  }

  bool _followAccentColor = true;

  /// Set background image option.
  ///
  /// **Settings name:** appsettings.appearance.backgroundimage.option
  BackgroundImageOption get backgroundImageOption => _backgroundImageOption;

  set backgroundImageOption(BackgroundImageOption value) {
    if (value == _backgroundImageOption) {
      return;
    }

    _backgroundImageOption = value;
    _settingsChanged();
  }

  BackgroundImageOption _backgroundImageOption = BackgroundImageOption.none;

  /// Make app background to black color. Only in dark mode.
  /// This won't work if [backgroundImageOption] is different than `none`.
  ///
  /// **Settings name:** appsettings.appearance.blackbackground
  bool get blackBackground => _blackBackground;

  set blackBackground(bool value) {
    if (value == _blackBackground) {
      return;
    }

    _blackBackground = value;
    _settingsChanged();
  }

  bool _blackBackground = false;

  ///
  ///
  /// **Settings name:** appsettings.appearance.backgroundimage.opacity.background
  double backgroundImageOpacity = 0.65;

  ///
  ///
  /// **Settings name:** appsettings.appearance.backgroundimage.opacity.component
  double componentOpacity = 0.65;

  // Miscellaneous
  /// Automatically find locale and set language from that.
  ///
  /// **Settings name:** appsettings.locale.auto
  bool get localeAuto => _localeAuto;

  set localeAuto(bool value) {
    _localeAuto = value;
    _settingsChanged();
  }

  bool _localeAuto = true;

  /// Set locale manually.
  ///
  /// **Settings name:** appsettings.locale.specific
  Locale get locale => _locale;

  set locale(Locale lo) {
    _locale = lo;
    _settingsChanged();
  }

  Locale _locale = Locale("en");

  /// Adjust school year. This will affect almost functions in `Accounts` screen.
  ///
  /// **Settings name:** appsettings.globalvariables.schoolyear
  SchoolYear get currentSchoolYear => _currentSchoolYear;

  set currentSchoolYear(SchoolYear value) {
    _currentSchoolYear = SchoolYear(year: value.year, semester: value.semester);
    _settingsChanged();
  }

  SchoolYear _currentSchoolYear = SchoolYear(year: 24, semester: 1);

  /// Open all links inside app. Disable to open these on external browser.
  ///
  /// **Settings name:** appsettings.miscellaneous.openlinkinsideapp
  bool get openLinkInsideApp => _openLinkInsideApp;

  set openLinkInsideApp(bool value) {
    _openLinkInsideApp = value;
    _settingsChanged();
  }

  bool _openLinkInsideApp = true;

  /// Is news opened in bottom sheet?
  /// * `true`: News will open in bottom sheet.
  /// * `false`: News will open in new activity.
  ///
  /// **Settings name:** appsettings.behavior.bottomsheetwhenclicknews</br>
  /// **Since:** v2.0-draft19
  bool get openNewsInModalBottomSheet => _openNewsInModalBottomSheet;

  set openNewsInModalBottomSheet(bool value) {
    _openNewsInModalBottomSheet = value;
    _settingsChanged();
  }

  bool _openNewsInModalBottomSheet = true;

  bool _pendingChanges = false;

  void _settingsChanged() async {
    if (!_isSettingsInitialized) {
      return;
    }
    while (_pendingChanges) {
      await Future.delayed(Duration(milliseconds: 100));
      // return;
    }

    _pendingChanges = true;
    notifyListeners();
    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'Settings',
      message: 'Modified changes! Saving...',
    );

    await StorageRepository.saveSettings(settings: _toMap());

    _pendingChanges = false;
    notifyListeners();
  }

  Map<String, dynamic> _toMap() {
    return {
      "appbehavior.firstrun.done": firstRunDone,
      "appsettings.locale.specific": locale.languageCode,
      "appsettings.locale.auto": localeAuto,
      "appsettings.appearance.thememode": themeMode.value,
      "appsettings.appearance.dynamiccolor": followAccentColor,
      "appsettings.appearance.blackbackground": blackBackground,
      "appsettings.appearance.backgroundimage.option": backgroundImageOption.value,
      "appsettings.appearance.backgroundimage.opacity.background": backgroundImageOpacity,
      "appsettings.appearance.backgroundimage.opacity.component": componentOpacity,
      "appsettings.miscellaneous.openlinkinsideapp": openLinkInsideApp,
      "appsettings.newsbackground.duration": newsBackgroundDuration,
      // "appsettings.newsbackground.filterlist": json.encode(newsBackgroundFilterList),
      "appsettings.newsbackground.filterlist": newsBackgroundFilterList.map((p) => p.toJson()).toList(),
      "appsettings.newsbackground.newsglobal.enabled": newsBackgroundGlobalEnabled,
      "appsettings.newsbackground.newssubject.enabled": newsBackgroundSubjectEnabled.value,
      "appsettings.newsbackground.newssubject.parsenotification": newsBackgroundParseNewsSubject,
      "appsettings.newsbackground.studentaffairs.enabled": newsBackgroundStudentAffairsEnabled,
      "appsettings.newsbackground.examination.enabled": newsBackgroundExaminationEnabled,
      "appsettings.newsbackground.tuitionfee.enabled": newsBackgroundTuitionFeeEnabled,
      // "appsettings.globalvariables.schoolyear": json.encode(currentSchoolYear),
      "appsettings.globalvariables.schoolyear": currentSchoolYear.toJson(),
      "appsettings.behavior.bottomsheetwhenclicknews": openNewsInModalBottomSheet,
    };
  }

  void _fromMap(Map<String, dynamic> data) {
    firstRunDone = (data["appbehavior.firstrun.done"] as bool?) ?? false;
    locale = Locale((data["appsettings.locale.specific"] as String?) ?? "en");
    localeAuto = (data["appsettings.locale.auto"] as bool?) ?? false;
    themeMode = AppThemeMode.values
            .where((p) => p.value == ((data["appsettings.appearance.thememode"] as int?) ?? -1))
            .firstOrNull ??
        AppThemeMode.followSystemSettings;
    followAccentColor = (data["appsettings.appearance.dynamiccolor"] as bool?) ?? true;
    blackBackground = (data["appsettings.appearance.blackbackground"] as bool?) ?? false;
    backgroundImageOption = BackgroundImageOption.values
            .where((p) => p.value == ((data["appsettings.appearance.backgroundimage.option"] as int?) ?? 0))
            .firstOrNull ??
        BackgroundImageOption.none;
    backgroundImageOpacity = (data["appsettings.appearance.backgroundimage.opacity.background"] as double?) ?? 0.65;
    componentOpacity = (data["appsettings.appearance.backgroundimage.opacity.component"] as double?) ?? 0.65;
    openLinkInsideApp = (data["appsettings.miscellaneous.openlinkinsideapp"] as bool?) ?? true;
    newsBackgroundDuration = (data["appsettings.newsbackground.duration"] as int?) ?? 0;
    // newsBackgroundFilterList = List<BackgroundSubjectCode>.from(
    //     (json.decode((data["appsettings.newsbackground.filterlist"] as String?) ?? "[]") as List)
    //         .map((p) => BackgroundSubjectCode.fromJson(p))
    //         .toList());
    newsBackgroundFilterList = (data["appsettings.newsbackground.filterlist"] as List<dynamic>? ?? [])
        .map((p) => BackgroundSubjectCode.fromJson(p))
        .toList();
    newsBackgroundGlobalEnabled = (data["appsettings.newsbackground.newsglobal.enabled"] as bool?) ?? true;
    newsBackgroundSubjectEnabled = NewsBackgroundSubjectType.values
            .where((p) => p.value == ((data["appsettings.newsbackground.newssubject.enabled"] as int?) ?? 0))
            .firstOrNull ??
        NewsBackgroundSubjectType.allNews;
    newsBackgroundParseNewsSubject =
        (data["appsettings.newsbackground.newssubject.parsenotification"] as bool?) ?? true;
    newsBackgroundStudentAffairsEnabled = (data["appsettings.newsbackground.studentaffairs.enabled"] as bool?) ?? true;
    newsBackgroundExaminationEnabled = (data["appsettings.newsbackground.examination.enabled"] as bool?) ?? true;
    newsBackgroundTuitionFeeEnabled = (data["appsettings.newsbackground.tuitionfee.enabled"] as bool?) ?? true;
    // currentSchoolYear =
    //     SchoolYear.fromJson(json.decode((data["appsettings.globalvariables.schoolyear"] as String?) ?? "{}"));
    currentSchoolYear =
        SchoolYear.fromJson(data["appsettings.globalvariables.schoolyear"] as Map<String, dynamic>? ?? {});
    openNewsInModalBottomSheet = (data["appsettings.behavior.bottomsheetwhenclicknews"] as bool?) ?? true;
  }
}
