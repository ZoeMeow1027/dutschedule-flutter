import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'background/bg_core.dart';
import 'global_variables.dart';
import 'repository/storage_repository.dart';
import 'ui/main_application.dart';
import 'viewmodel/account_session_instance.dart';
import 'viewmodel/news_cache_instance.dart';
import 'viewmodel/news_search_instance.dart';
import 'viewmodel/settings_instance.dart';

void main() async {
  // Initialize settings instance
  var settingsInstance = SettingsInstance.fromPreviousSettings(await StorageRepository.getPreviousSettings());
  // Initialize account session instance
  var accountSessionInstance = AccountSessionInstance.fromPreviousSettings(
    accountSessionJson: await StorageRepository.loadAccountSession(),
  );
  accountSessionInstance.schoolYear = settingsInstance.currentSchoolYear;
  // Initialize news cache instance
  var newsCacheInstance = NewsCacheInstance();
  // Initialize news search instance
  var newsSearchInstance = NewsSearchInstance.fromPreviousSettings(
    newsSearchJson: await StorageRepository.getNewsSearchHistory(),
  );

  // Ensure is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Extract app version to global variables
  GlobalVariables.appVersion = (await PackageInfo.fromPlatform()).version;
  GlobalVariables.appBuildNumber = (await PackageInfo.fromPlatform()).buildNumber;

  // await AppUtils.checkIfAnotherInstanceIsRunning();
  // await AppUtils.distroyAndCreateNewSystemTray();
  // await AppUtils.hideWindowAtLaunch();

  await BackgroundTask.scheduleNewsBackgroundTaskOnDesktop(
    newsCacheInstance: newsCacheInstance,
    settingsInstance: settingsInstance,
    runNow: false,
  );

  // Run the app with providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => settingsInstance),
        ChangeNotifierProvider(create: (context) => newsCacheInstance),
        ChangeNotifierProvider(create: (context) => newsSearchInstance),
        ChangeNotifierProvider(create: (context) => accountSessionInstance),
      ],
      child: const MainApplication(),
    ),
  );
}
