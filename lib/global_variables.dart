import 'package:dutwrapper/utils_object.dart';

class GlobalVariables {
  static const int requestExpiredDuration = 1000 * 60 * 5;

  static const String repoLink = 'https://github.com/ZoeMeow1027/DutSchedule';
  static const String repoLinkForgotPassword = '$repoLink/wiki/Changing-Password-In-DUT#qu%C3%AAn-m%E1%BA%ADt-kh%E1%BA%A9u';
  static const String repoLinkLicense = '$repoLink/blob/stable/LICENSE';
  static const String repoLinkCredits = '$repoLink?tab=readme-ov-file#credits-and-license';
  static const String repoLinkReleases = '$repoLink/releases';
  static const String repoLinkChangelog = '$repoLink/blob/stable/CHANGELOG.md';

  static const String appDisplayName = 'DutSchedule';
  static const String appDirRoot = 'ZoeMeow.DutSchedule';
  static const String appPathFileSettings = 'settings.json';
  static const String appPathNotificationHistory = 'notifications.history.json';
  static const String appPathNewsCache = 'news.cache.json';
  static const String appPathFileNewsSearchHistory = 'news.searchhistory.json';
  static const String appPathFileAccountSession = 'account.session.json';
  static const String appPathFileAccountCache = 'account.cache.json';

  // Initialize app version and app build number from main().
  // WARNING: Do not edit these strings. This will generated when running.
  static String appVersion = '0.0.0';
  static String appBuildNumber = '0';

  // WARNING: Do not edit these variables. This will generated when running.
  static DutSchoolYear? dutSchoolYear;
}
