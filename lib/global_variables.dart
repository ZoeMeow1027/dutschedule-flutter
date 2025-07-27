import 'package:dutwrapper/utils_object.dart';

class GlobalVariables {
  static int requestExpiredDuration = 1000 * 60 * 5;

  static String repoLink = 'https://github.com/ZoeMeow1027/DutSchedule';
  static String repoLinkForgotPassword = '$repoLink/wiki/Changing-Password-In-DUT#qu%C3%AAn-m%E1%BA%ADt-kh%E1%BA%A9u';
  static String repoLinkLicense = '$repoLink/blob/stable/LICENSE';
  static String repoLinkCredits = '$repoLink?tab=readme-ov-file#credits-and-license';
  static String repoLinkReleases = '$repoLink/releases';
  static String repoLinkChangelog = '$repoLink/blob/stable/CHANGELOG.md';

  static String appDisplayName = 'DutSchedule';
  static String appDirRoot = 'ZoeMeow.DutSchedule';
  static String appPathFileSettings = 'settings.json';
  static String appPathNotificationHistory = 'notifications.history.json';
  static String appPathNewsCache = 'news.cache.json';
  static String appPathFileNewsSearchHistory = 'news.searchhistory.json';
  static String appPathFileAccountSession = 'account.session.json';

  // Initialize app version and app build number from main().
  // WARNING: Do not edit these strings. This will generated when running.
  static String appVersion = '0.0.0';
  static String appBuildNumber = '0';

  // WARNING: Do not edit these variables. This will generated when running.
  static DutSchoolYear? dutSchoolYear;
}
