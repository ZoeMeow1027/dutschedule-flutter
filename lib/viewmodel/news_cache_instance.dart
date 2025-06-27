import 'package:dutwrapper/news.dart';
import 'package:dutwrapper/news_object.dart';

import '../model/process_state.dart';
import '../model/variable_state.dart';
import '../utils/app_utils.dart';
import 'base_view_model.dart';

enum NewsFetchType {
  nextPage,
  firstPage,
  clearCacheAndFirstPage,
}

class NewsCacheInstance extends BaseViewModel {
  @override
  void initializing() {}

  @override
  void timerAction() {}

  VariableListState<NewsGlobal> newsGlobal = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1", "endOfList": "0"},
  );

  VariableListState<NewsSubject> newsSubject = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1", "endOfList": "0"},
  );

  VariableListState<NewsGlobal> newsStudentAffairs = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1", "endOfList": "0"},
  );

  VariableListState<NewsGlobal> newsExamination = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1", "endOfList": "0"},
  );

  VariableListState<NewsGlobal> newsTuitions = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1", "endOfList": "0"},
  );

  VariableListState<NewsGlobal> newsStatuteRegulation = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1", "endOfList": "0"},
  );

  Future<void> fetchGlobalNews({
    NewsFetchType fetchType = NewsFetchType.nextPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    if (!newsGlobal.isSuccessfulRequestExpired() && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Global',
        message: 'Denied this task because of timeout. Force this request to continue.',
      );
      return;
    }
    if (newsGlobal.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Global',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }

    if (newsGlobal.parameters["endOfList"] == "1" &&
        ![NewsFetchType.clearCacheAndFirstPage, NewsFetchType.firstPage].contains(fetchType)) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Global',
        message: "You're reached end of list. "
            "Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.",
      );
      return;
    }

    newsGlobal.state = ProcessState.running;
    notifyListeners();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'News',
      subTag: 'Global',
      message: "Running...",
    );

    List<NewsGlobal> latestNews = [];
    try {
      var listFromInternet = await News.getNewsGlobal(
        page: fetchType == NewsFetchType.nextPage ? (int.tryParse(newsGlobal.parameters["nextPage"] ?? "") ?? 1) : 1,
      );

      if (fetchType == NewsFetchType.clearCacheAndFirstPage) {
        newsGlobal.data.clear();
        latestNews.addAll(listFromInternet);
      } else if (fetchType == NewsFetchType.nextPage) {
        latestNews.addAll(listFromInternet);
      } else {
        for (var item in listFromInternet) {
          var anyMatch = newsGlobal.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) == 0)) {
              return true;
            }
            return false;
          });
          var anyNeedUpdated = newsGlobal.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) != 0)) {
              return true;
            }
            return false;
          });

          // Ignore when entire match
          if (anyMatch) {
          }
          // Update when match date and title
          else if (anyNeedUpdated) {
            newsGlobal.data.firstWhere((p) => p.date == item.date && p.title == item.title)
              ..title = item.title
              ..contentHtml = item.contentHtml
              ..resources.clear()
              ..resources.addAll(item.resources);
          }
          // Otherwise, add to latest news collection
          else {
            latestNews.add(item);
          }
        }
      }

      // Reverse latest news collection
      // Add all news in latestNews to global variable
      if (fetchType == NewsFetchType.firstPage) {
        for (var value in latestNews.reversed) {
          newsGlobal.data.insert(0, value);
        }
      } else {
        newsGlobal.data.addAll(latestNews);
      }

      // Adjust index
      switch (fetchType) {
        // Increase by 1
        case NewsFetchType.nextPage:
          newsGlobal.parameters["nextPage"] =
              ((int.tryParse(newsGlobal.parameters["nextPage"] ?? "") ?? 1) + 1).toString();
          break;
        // Just keep current
        case NewsFetchType.firstPage:
          newsGlobal.parameters["nextPage"] = (int.tryParse(newsGlobal.parameters["nextPage"] ?? "") ?? 1).toString();
          break;
        // Set to 2
        case NewsFetchType.clearCacheAndFirstPage:
          newsGlobal.parameters["nextPage"] = 2.toString();
          break;
      }

      // If listFromInternet is less than 30 items, might be end of list.
      newsGlobal.parameters["endOfList"] = (listFromInternet.length < 30) ? "1" : "0";

      newsGlobal.state = ProcessState.successful;
      newsGlobal.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'News',
        subTag: 'Global',
        message: "Task done successfully!",
      );
    } catch (ex) {
      newsGlobal.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'News',
        subTag: 'Global',
        message: "Task failed!",
      );
    } finally {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'News',
        subTag: 'Global',
        message: "Task done! Next page: ${newsGlobal.parameters["nextPage"] ?? "???"}, "
            "current count: ${newsGlobal.data.length}",
      );
      notifyListeners();

      onDone?.call(newsGlobal.state == ProcessState.successful);
    }
  }

  Future<void> fetchSubjectNews({
    NewsFetchType fetchType = NewsFetchType.nextPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    if (!newsSubject.isSuccessfulRequestExpired() && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Subject',
        message: 'Denied this task because of timeout. Force this request to continue.',
      );
      return;
    }
    if (newsSubject.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Subject',
        message: 'Denied this task because of timeout. Force this request to continue.',
      );
      return;
    }

    if (newsSubject.parameters["endOfList"] == "1" &&
        ![NewsFetchType.clearCacheAndFirstPage, NewsFetchType.firstPage].contains(fetchType)) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Subject',
        message: "You're reached end of list. "
            "Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.",
      );
      return;
    }

    newsSubject.state = ProcessState.running;
    notifyListeners();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'News',
      subTag: 'Subject',
      message: "Running...",
    );

    List<NewsSubject> latestNews = [];
    try {
      var listFromInternet = await News.getNewsSubject(
        page: fetchType == NewsFetchType.nextPage ? (int.tryParse(newsSubject.parameters["nextPage"] ?? "") ?? 1) : 1,
      );

      if (fetchType == NewsFetchType.clearCacheAndFirstPage) {
        newsSubject.data.clear();
        latestNews.addAll(listFromInternet);
      } else if (fetchType == NewsFetchType.nextPage) {
        latestNews.addAll(listFromInternet);
      } else {
        for (var item in listFromInternet) {
          var anyMatch = newsSubject.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) == 0)) {
              return true;
            }
            return false;
          });
          var anyNeedUpdated = newsSubject.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) != 0)) {
              return true;
            }
            return false;
          });

          // Ignore when entire match
          if (anyMatch) {
          }
          // Update when match date and title
          else if (anyNeedUpdated) {
            newsSubject.data.firstWhere((p) => p.date == item.date && p.title == item.title)
              ..title = item.title
              ..contentHtml = item.contentHtml
              ..resources.clear()
              ..resources.addAll(item.resources);
          }
          // Otherwise, add to latest news collection
          else {
            latestNews.add(item);
          }
        }
      }

      // Reverse latest news collection
      // Add all news in latestNews to global variable
      if (fetchType == NewsFetchType.firstPage) {
        for (var value in latestNews.reversed) {
          newsSubject.data.insert(0, value);
        }
      } else {
        newsSubject.data.addAll(latestNews);
      }

      // Adjust index
      switch (fetchType) {
        // Increase by 1
        case NewsFetchType.nextPage:
          newsSubject.parameters["nextPage"] =
              ((int.tryParse(newsSubject.parameters["nextPage"] ?? "") ?? 1) + 1).toString();
          break;
        // Just keep current
        case NewsFetchType.firstPage:
          newsSubject.parameters["nextPage"] = (int.tryParse(newsSubject.parameters["nextPage"] ?? "") ?? 1).toString();
          break;
        // Set to 2
        case NewsFetchType.clearCacheAndFirstPage:
          newsSubject.parameters["nextPage"] = 2.toString();
          break;
      }

      // If listFromInternet is less than 30 items, might be end of list.
      newsSubject.parameters["endOfList"] = (listFromInternet.length < 30) ? "1" : "0";

      newsSubject.state = ProcessState.successful;
      newsSubject.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'News',
        subTag: 'Subject',
        message: "Task done successfully!",
      );
    } catch (ex) {
      newsSubject.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'News',
        subTag: 'Subject',
        message: "Task failed!",
      );
    } finally {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'News',
        subTag: 'Subject',
        message: "Task done! Next page: ${newsSubject.parameters["nextPage"] ?? "???"}, "
            "current count: ${newsSubject.data.length}",
      );
      notifyListeners();

      onDone?.call(newsSubject.state == ProcessState.successful);
    }
  }

  Future<void> fetchNewsStudentAffairs({
    NewsFetchType fetchType = NewsFetchType.nextPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    if (!newsStudentAffairs.isSuccessfulRequestExpired() && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Student Affairs',
        message: 'Denied this task because of timeout. Force this request to continue.',
      );
      return;
    }
    if (newsStudentAffairs.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Student Affairs',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }

    if (newsStudentAffairs.parameters["endOfList"] == "1" &&
        ![NewsFetchType.clearCacheAndFirstPage, NewsFetchType.firstPage].contains(fetchType)) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Student Affairs',
        message: "You're reached end of list. "
            "Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.",
      );
      return;
    }

    newsStudentAffairs.state = ProcessState.running;
    notifyListeners();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'News',
      subTag: 'Student Affairs',
      message: "Running...",
    );

    List<NewsGlobal> latestNews = [];
    try {
      var listFromInternet = await News.getNewsStudentAffairs(
        page: fetchType == NewsFetchType.nextPage
            ? (int.tryParse(newsStudentAffairs.parameters["nextPage"] ?? "") ?? 1)
            : 1,
      );

      if (fetchType == NewsFetchType.clearCacheAndFirstPage) {
        newsStudentAffairs.data.clear();
        latestNews.addAll(listFromInternet);
      } else if (fetchType == NewsFetchType.nextPage) {
        latestNews.addAll(listFromInternet);
      } else {
        for (var item in listFromInternet) {
          var anyMatch = newsStudentAffairs.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) == 0)) {
              return true;
            }
            return false;
          });
          var anyNeedUpdated = newsStudentAffairs.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) != 0)) {
              return true;
            }
            return false;
          });

          // Ignore when entire match
          if (anyMatch) {
          }
          // Update when match date and title
          else if (anyNeedUpdated) {
            newsStudentAffairs.data.firstWhere((p) => p.date == item.date && p.title == item.title)
              ..title = item.title
              ..contentHtml = item.contentHtml
              ..resources.clear()
              ..resources.addAll(item.resources);
          }
          // Otherwise, add to latest news collection
          else {
            latestNews.add(item);
          }
        }
      }

      // Reverse latest news collection
      // Add all news in latestNews to global variable
      if (fetchType == NewsFetchType.firstPage) {
        for (var value in latestNews.reversed) {
          newsStudentAffairs.data.insert(0, value);
        }
      } else {
        newsStudentAffairs.data.addAll(latestNews);
      }

      // Adjust index
      switch (fetchType) {
        // Increase by 1
        case NewsFetchType.nextPage:
          newsStudentAffairs.parameters["nextPage"] =
              ((int.tryParse(newsStudentAffairs.parameters["nextPage"] ?? "") ?? 1) + 1).toString();
          break;
        // Just keep current
        case NewsFetchType.firstPage:
          newsStudentAffairs.parameters["nextPage"] =
              (int.tryParse(newsStudentAffairs.parameters["nextPage"] ?? "") ?? 1).toString();
          break;
        // Set to 2
        case NewsFetchType.clearCacheAndFirstPage:
          newsStudentAffairs.parameters["nextPage"] = 2.toString();
          break;
      }

      // If listFromInternet is less than 30 items, might be end of list.
      newsStudentAffairs.parameters["endOfList"] = (listFromInternet.length < 30) ? "1" : "0";

      newsStudentAffairs.state = ProcessState.successful;
      newsStudentAffairs.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'News',
        subTag: 'Student Affairs',
        message: "Task done successfully!",
      );
    } catch (ex) {
      newsStudentAffairs.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'News',
        subTag: 'Student Affairs',
        message: "Task failed!",
      );
    } finally {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'News',
        subTag: 'Student Affairs',
        message: "Task done! Next page: ${newsStudentAffairs.parameters["nextPage"] ?? "???"}, "
            "current count: ${newsStudentAffairs.data.length}",
      );
      notifyListeners();

      onDone?.call(newsStudentAffairs.state == ProcessState.successful);
    }
  }

  Future<void> fetchNewsExamination({
    NewsFetchType fetchType = NewsFetchType.nextPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    if (!newsExamination.isSuccessfulRequestExpired() && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Examination',
        message: 'Denied this task because of timeout. Force this request to continue.',
      );
      return;
    }
    if (newsExamination.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Examination',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }

    if (newsExamination.parameters["endOfList"] == "1" &&
        ![NewsFetchType.clearCacheAndFirstPage, NewsFetchType.firstPage].contains(fetchType)) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Examination',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }

    newsExamination.state = ProcessState.running;
    notifyListeners();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'News',
      subTag: 'Examination',
      message: "Running...",
    );

    List<NewsGlobal> latestNews = [];
    try {
      var listFromInternet = await News.getNewsExamination(
        page:
            fetchType == NewsFetchType.nextPage ? (int.tryParse(newsExamination.parameters["nextPage"] ?? "") ?? 1) : 1,
      );

      if (fetchType == NewsFetchType.clearCacheAndFirstPage) {
        newsExamination.data.clear();
        latestNews.addAll(listFromInternet);
      } else if (fetchType == NewsFetchType.nextPage) {
        latestNews.addAll(listFromInternet);
      } else {
        for (var item in listFromInternet) {
          var anyMatch = newsExamination.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) == 0)) {
              return true;
            }
            return false;
          });
          var anyNeedUpdated = newsExamination.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) != 0)) {
              return true;
            }
            return false;
          });

          // Ignore when entire match
          if (anyMatch) {
          }
          // Update when match date and title
          else if (anyNeedUpdated) {
            newsExamination.data.firstWhere((p) => p.date == item.date && p.title == item.title)
              ..title = item.title
              ..contentHtml = item.contentHtml
              ..resources.clear()
              ..resources.addAll(item.resources);
          }
          // Otherwise, add to latest news collection
          else {
            latestNews.add(item);
          }
        }
      }

      // Reverse latest news collection
      // Add all news in latestNews to global variable
      if (fetchType == NewsFetchType.firstPage) {
        for (var value in latestNews.reversed) {
          newsExamination.data.insert(0, value);
        }
      } else {
        newsExamination.data.addAll(latestNews);
      }

      // Adjust index
      switch (fetchType) {
        // Increase by 1
        case NewsFetchType.nextPage:
          newsExamination.parameters["nextPage"] =
              ((int.tryParse(newsExamination.parameters["nextPage"] ?? "") ?? 1) + 1).toString();
          break;
        // Just keep current
        case NewsFetchType.firstPage:
          newsExamination.parameters["nextPage"] =
              (int.tryParse(newsExamination.parameters["nextPage"] ?? "") ?? 1).toString();
          break;
        // Set to 2
        case NewsFetchType.clearCacheAndFirstPage:
          newsExamination.parameters["nextPage"] = 2.toString();
          break;
      }

      // If listFromInternet is less than 30 items, might be end of list.
      newsExamination.parameters["endOfList"] = (listFromInternet.length < 30) ? "1" : "0";

      newsExamination.state = ProcessState.successful;
      newsExamination.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'News',
        subTag: 'Examination',
        message: "Task done successfully!",
      );
    } catch (ex) {
      newsExamination.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'News',
        subTag: 'Examination',
        message: "Task failed!",
      );
    } finally {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'News',
        subTag: 'Examination',
        message: "Task done! Next page: ${newsExamination.parameters["nextPage"] ?? "???"}, "
            "current count: ${newsExamination.data.length}",
      );
      notifyListeners();

      onDone?.call(newsExamination.state == ProcessState.successful);
    }
  }

  Future<void> fetchNewsTuitionFee({
    NewsFetchType fetchType = NewsFetchType.nextPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    if (!newsTuitions.isSuccessfulRequestExpired() && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Tuition fee',
        message: 'Denied this task because of timeout. Force this request to continue.',
      );
      return;
    }
    if (newsTuitions.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Tuition fee',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }

    if (newsTuitions.parameters["endOfList"] == "1" &&
        ![NewsFetchType.clearCacheAndFirstPage, NewsFetchType.firstPage].contains(fetchType)) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Tuition fee',
        message: "You're reached end of list. "
            "Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.",
      );
      return;
    }

    newsTuitions.state = ProcessState.running;
    notifyListeners();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'News',
      subTag: 'Tuition fee',
      message: "Running...",
    );

    List<NewsGlobal> latestNews = [];
    try {
      var listFromInternet = await News.getNewsTuitionFee(
        page: fetchType == NewsFetchType.nextPage ? (int.tryParse(newsTuitions.parameters["nextPage"] ?? "") ?? 1) : 1,
      );

      if (fetchType == NewsFetchType.clearCacheAndFirstPage) {
        newsTuitions.data.clear();
        latestNews.addAll(listFromInternet);
      } else if (fetchType == NewsFetchType.nextPage) {
        latestNews.addAll(listFromInternet);
      } else {
        for (var item in listFromInternet) {
          var anyMatch = newsTuitions.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) == 0)) {
              return true;
            }
            return false;
          });
          var anyNeedUpdated = newsTuitions.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) != 0)) {
              return true;
            }
            return false;
          });

          // Ignore when entire match
          if (anyMatch) {
          }
          // Update when match date and title
          else if (anyNeedUpdated) {
            newsTuitions.data.firstWhere((p) => p.date == item.date && p.title == item.title)
              ..title = item.title
              ..contentHtml = item.contentHtml
              ..resources.clear()
              ..resources.addAll(item.resources);
          }
          // Otherwise, add to latest news collection
          else {
            latestNews.add(item);
          }
        }
      }

      // Reverse latest news collection
      // Add all news in latestNews to global variable
      if (fetchType == NewsFetchType.firstPage) {
        for (var value in latestNews.reversed) {
          newsTuitions.data.insert(0, value);
        }
      } else {
        newsTuitions.data.addAll(latestNews);
      }

      // Adjust index
      switch (fetchType) {
        // Increase by 1
        case NewsFetchType.nextPage:
          newsTuitions.parameters["nextPage"] =
              ((int.tryParse(newsTuitions.parameters["nextPage"] ?? "") ?? 1) + 1).toString();
          break;
        // Just keep current
        case NewsFetchType.firstPage:
          newsTuitions.parameters["nextPage"] =
              (int.tryParse(newsTuitions.parameters["nextPage"] ?? "") ?? 1).toString();
          break;
        // Set to 2
        case NewsFetchType.clearCacheAndFirstPage:
          newsTuitions.parameters["nextPage"] = 2.toString();
          break;
      }

      // If listFromInternet is less than 30 items, might be end of list.
      newsTuitions.parameters["endOfList"] = (listFromInternet.length < 30) ? "1" : "0";

      newsTuitions.state = ProcessState.successful;
      newsTuitions.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'News',
        subTag: 'Tuition fee',
        message: "Task done successfully!",
      );
    } catch (ex) {
      newsTuitions.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'News',
        subTag: 'Tuition fee',
        message: "Task failed!",
      );
    } finally {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'News',
        subTag: 'Tuition fee',
        message: "Task done! Next page: ${newsTuitions.parameters["nextPage"] ?? "???"}, "
            "current count: ${newsTuitions.data.length}",
      );
      notifyListeners();

      onDone?.call(newsTuitions.state == ProcessState.successful);
    }
  }

  Future<void> fetchNewsStatuteRegulation({
    NewsFetchType fetchType = NewsFetchType.nextPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    if (!newsStatuteRegulation.isSuccessfulRequestExpired() && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Statute & policy',
        message: 'Denied this task because of timeout. Force this request to continue.',
      );
      return;
    }
    if (newsStatuteRegulation.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Statute & policy',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }

    if (newsStatuteRegulation.parameters["endOfList"] == "1" &&
        ![NewsFetchType.clearCacheAndFirstPage, NewsFetchType.firstPage].contains(fetchType)) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: 'Statute & policy',
        message: "You're reached end of list. "
            "Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.",
      );
      return;
    }

    newsStatuteRegulation.state = ProcessState.running;
    notifyListeners();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'News',
      subTag: 'Statute & policy',
      message: "Running...",
    );

    List<NewsGlobal> latestNews = [];
    try {
      // TODO: Wait for library update for this
      var listFromInternet = await News.getNewsStatutePolicy(
        page: fetchType == NewsFetchType.nextPage
            ? (int.tryParse(newsStatuteRegulation.parameters["nextPage"] ?? "") ?? 1)
            : 1,
      );

      if (fetchType == NewsFetchType.clearCacheAndFirstPage) {
        newsStatuteRegulation.data.clear();
        latestNews.addAll(listFromInternet);
      } else if (fetchType == NewsFetchType.nextPage) {
        latestNews.addAll(listFromInternet);
      } else {
        for (var item in listFromInternet) {
          var anyMatch = newsStatuteRegulation.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) == 0)) {
              return true;
            }
            return false;
          });
          var anyNeedUpdated = newsStatuteRegulation.data.any((p) {
            if ((p.date == item.date) &&
                (p.title.compareTo(item.title) == 0) &&
                (p.contentHtml.compareTo(item.contentHtml) != 0)) {
              return true;
            }
            return false;
          });

          // Ignore when entire match
          if (anyMatch) {
          }
          // Update when match date and title
          else if (anyNeedUpdated) {
            newsStatuteRegulation.data.firstWhere((p) => p.date == item.date && p.title == item.title)
              ..title = item.title
              ..contentHtml = item.contentHtml
              ..resources.clear()
              ..resources.addAll(item.resources);
          }
          // Otherwise, add to latest news collection
          else {
            latestNews.add(item);
          }
        }
      }

      // Reverse latest news collection
      // Add all news in latestNews to global variable
      if (fetchType == NewsFetchType.firstPage) {
        for (var value in latestNews.reversed) {
          newsStatuteRegulation.data.insert(0, value);
        }
      } else {
        newsStatuteRegulation.data.addAll(latestNews);
      }

      // Adjust index
      switch (fetchType) {
        // Increase by 1
        case NewsFetchType.nextPage:
          newsStatuteRegulation.parameters["nextPage"] =
              ((int.tryParse(newsStatuteRegulation.parameters["nextPage"] ?? "") ?? 1) + 1).toString();
          break;
        // Just keep current
        case NewsFetchType.firstPage:
          newsStatuteRegulation.parameters["nextPage"] =
              (int.tryParse(newsStatuteRegulation.parameters["nextPage"] ?? "") ?? 1).toString();
          break;
        // Set to 2
        case NewsFetchType.clearCacheAndFirstPage:
          newsStatuteRegulation.parameters["nextPage"] = 2.toString();
          break;
      }

      // If listFromInternet is less than 30 items, might be end of list.
      newsStatuteRegulation.parameters["endOfList"] = (listFromInternet.length < 30) ? "1" : "0";

      newsStatuteRegulation.state = ProcessState.successful;
      newsStatuteRegulation.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'News',
        subTag: 'Statute & policy',
        message: "Task done successfully!",
      );
    } catch (ex) {
      newsStatuteRegulation.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'News',
        subTag: 'Statute & policy',
        message: "Task failed!",
      );
    } finally {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'News',
        subTag: 'Statute & policy',
        message: "Task done! Next page: ${newsStatuteRegulation.parameters["nextPage"] ?? "???"}, "
            "current count: ${newsStatuteRegulation.data.length}",
      );
      notifyListeners();

      onDone?.call(newsStatuteRegulation.state == ProcessState.successful);
    }
  }
}
