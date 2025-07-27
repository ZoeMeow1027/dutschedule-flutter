import 'dart:async';

import '../model/enum/news_background_subject_type.dart';
import '../model/enum/news_fetching_type.dart';
import '../utils/app_utils.dart';
import '../utils/task_scheduler.dart';
import '../viewmodel/account_session_instance.dart';
import '../viewmodel/news_cache_instance_v2.dart';
import '../viewmodel/settings_instance.dart';

class BackgroundTask {
  static Future<void> runBackgroundTask() async {
    // Your custom logic
    while (true) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'BackgroundService',
        message: 'Running background task...',
      );
      await Future.delayed(Duration(minutes: 5));
    }
  }

  static Future<void> scheduleNewsBackgroundTaskOnDesktop({
    required NewsCacheInstanceV2 newsCacheInstance,
    required SettingsInstance settingsInstance,
    bool runNow = false,
  }) async {
    final scheduler = TaskScheduler();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'BackgroundService',
      subTag: 'News',
      message: 'Scheduling task...',
    );
    if (settingsInstance.newsBackgroundDuration >= 5) {
      if (scheduler.containsTask('fetch_news')) {
        scheduler.updateTaskInterval('fetch_news', Duration(minutes: settingsInstance.newsBackgroundDuration));
      } else {
        scheduler.addTask(
          name: 'fetch_news',
          interval: Duration(minutes: settingsInstance.newsBackgroundDuration),
          triggerAfterCreated: runNow,
          callback: () async => await _onNewsBackgroundTaskOnDesktop(
            newsCacheInstance: newsCacheInstance,
            settingsInstance: settingsInstance,
          ),
        );
      }
    } else {
      scheduler.removeTask('fetch_news');
    }
  }

  static Future<void> _onNewsBackgroundTaskOnDesktop({
    required NewsCacheInstanceV2 newsCacheInstance,
    required SettingsInstance settingsInstance,
  }) async {
    AppUtils.showLogToDebug(resultTag: AppLogLevel.debug, tag: 'News', subTag: 'NewsCache', message: 'Triggered');
    if (settingsInstance.newsBackgroundGlobalEnabled) {
      newsCacheInstance.fetchNewsGlobal(
        fetchType: NewsFetchingType.firstPage,
        forceRequest: true,
      );
    }
    if (settingsInstance.newsBackgroundSubjectEnabled != NewsBackgroundSubjectType.none) {
      newsCacheInstance.fetchNewsSubject(
        fetchType: NewsFetchingType.firstPage,
        forceRequest: true,
      );
    }
    if (settingsInstance.newsBackgroundStudentAffairsEnabled) {
      newsCacheInstance.fetchNewsStudentAffairs(
        fetchType: NewsFetchingType.firstPage,
        forceRequest: true,
      );
    }
    if (settingsInstance.newsBackgroundExaminationEnabled) {
      newsCacheInstance.fetchNewsExamination(
        fetchType: NewsFetchingType.firstPage,
        forceRequest: true,
      );
    }
    if (settingsInstance.newsBackgroundTuitionFeeEnabled) {
      newsCacheInstance.fetchNewsTuitionFee(
        fetchType: NewsFetchingType.firstPage,
        forceRequest: true,
      );
    }
    if (settingsInstance.newsBackgroundStatuteRegulationEnabled) {
      newsCacheInstance.fetchNewsStatuteRegulation(
        fetchType: NewsFetchingType.firstPage,
        forceRequest: true,
      );
    }
  }

  static Future<void> scheduleAccountBackgroundTaskOnDesktop({
    required AccountSessionInstance accountSessionInstance,
    required SettingsInstance settingsInstance,
    bool runNow = false,
  }) async {
    final scheduler = TaskScheduler();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'BackgroundService',
      subTag: 'Account',
      message: 'Scheduling task...',
    );
    if (settingsInstance.newsBackgroundDuration >= 5) {
      if (scheduler.containsTask('fetch_account')) {
        scheduler.updateTaskInterval('fetch_account', Duration(minutes: 0));
      } else {
        scheduler.addTask(
          name: 'fetch_account',
          interval: Duration(minutes: 0),
          triggerAfterCreated: runNow,
          callback: () async => await _onAccountBackgroundTaskOnDesktop(
            accountSessionInstance: accountSessionInstance,
            settingsInstance: settingsInstance,
          ),
        );
      }
    } else {
      scheduler.removeTask('fetch_account');
    }
  }

  static Future<void> _onAccountBackgroundTaskOnDesktop({
    required AccountSessionInstance accountSessionInstance,
    required SettingsInstance settingsInstance,
  }) async {
    // TODO: Check account status here!
  }
}
