import 'dart:developer';

import 'package:dutwrapper/news.dart';
import 'package:dutwrapper/news_object.dart';

import '../model/process_state.dart';
import '../model/variable_state.dart';
import 'base_view_model.dart';

enum NewsFetchType {
  nextPage,
  firstPage,
  clearCacheAndFirstPage,
}

class NewsCacheInstance extends BaseViewModel {
  @override
  void initializing() {
    // fetchGlobalNews(fetchType: NewsFetchType.firstPage);
    // fetchSubjectNews(fetchType: NewsFetchType.firstPage);

    // timerInterval = 60000;
  }

  @override
  void timerAction() {
    log("[News Cache] Triggered");

    fetchGlobalNews(fetchType: NewsFetchType.firstPage);
    fetchSubjectNews(fetchType: NewsFetchType.firstPage);
    fetchNewsStudentAffairs(fetchType: NewsFetchType.firstPage);
    fetchNewsExamination(fetchType: NewsFetchType.firstPage);
    fetchNewsTuitionFee(fetchType: NewsFetchType.firstPage);
  }

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

  // Future<void> _fetchCore<T>({
  //   required VariableListState<T> variableList,
  //   required String logHeader,
  //   NewsFetchType fetchType = NewsFetchType.nextPage,
  //   // Need to return something like: processState, clearOldNews, newsListToAdd, newsListAddBefore
  //   required Future<void> Function() doTask,
  //   bool forceRequest = false,
  //   Function()? beforeTask,
  //   Function()? afterTask,
  // }) async {
  //   if (variableList.isSuccessfulRequestExpired() && !forceRequest) {
  //     log("[$logHeader] Task start failed because of timeout. Force this request to continue.");
  //     return;
  //   }
  //   if (variableList.state == ProcessState.running) {
  //     log("[$logHeader] Task start failed because of running...");
  //     return;
  //   }
  //   if (variableList.parameters["endOfList"] == "1" && fetchType != NewsFetchType.clearCacheAndFirstPage) {
  //     log("[$logHeader] You're reached end of list. "
  //         "Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.");
  //     return;
  //   }

  //   // Before fetching news.
  //   beforeTask?.call();

  //   variableList.state = ProcessState.running;
  //   notifyListeners();

  //   await doTask();
  //   notifyListeners();

  //   switch (variableList.state) {
  //     case ProcessState.successful:
  //       variableList.lastRequest = DateTime.now().millisecondsSinceEpoch;
  //       log("[$logHeader] Task successful!");
  //       break;
  //     case ProcessState.failed:
  //       log("[$logHeader] Task failed!");
  //       break;
  //     default:
  //       break;
  //   }
  //   notifyListeners();

  //   // Check if end of list
  //   if (newsGlobal.parameters["endOfList"] == "1" && fetchType != NewsFetchType.clearCacheAndFirstPage) {
  //     log("[$logHeader] Task done! This news type reached end of list.");
  //   } else {
  //     log("[$logHeader] Task done! Next page: ${variableList.parameters["nextPage"] ?? "???"}, current count: ${variableList.data.length}");
  //   }

  //   // After task.
  //   afterTask?.call();
  // }

  Future<void> fetchGlobalNews({
    NewsFetchType fetchType = NewsFetchType.nextPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    if (!newsGlobal.isSuccessfulRequestExpired() && !forceRequest) {
      log("[News global] Task start failed because of timeout. Force this request to continue.");
      return;
    }
    if (newsGlobal.state == ProcessState.running) {
      log("[News global] Task start failed because another same task is running...");
      return;
    }

    if (newsGlobal.parameters["endOfList"] == "1" && fetchType != NewsFetchType.clearCacheAndFirstPage) {
      log("[News global] You're reached end of list. "
          "Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.");
      return;
    }

    newsGlobal.state = ProcessState.running;
    notifyListeners();

    log("[News global] Running...");

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
      if (listFromInternet.length < 30) {
        newsGlobal.parameters["endOfList"] = "1";
      }

      newsGlobal.state = ProcessState.successful;
      newsGlobal.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[News global] Task successful!");
    } catch (ex) {
      newsGlobal.state = ProcessState.failed;
      log("[News global] Task failed!");
    } finally {
      log("[News global] Task done! Next page: ${newsGlobal.parameters["nextPage"] ?? "???"}, current count: ${newsGlobal.data.length}");
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
      log("[News subject] Task start failed because of timeout. Force this request to continue.");
      return;
    }
    if (newsSubject.state == ProcessState.running) {
      log("[News subject] Task start failed because another same task is running...");
      return;
    }

    if (newsSubject.parameters["endOfList"] == "1" && fetchType != NewsFetchType.clearCacheAndFirstPage) {
      log("[News subject] You're reached end of list. Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.");
      return;
    }

    newsSubject.state = ProcessState.running;
    notifyListeners();

    log("[News subject] Running...");

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
      if (listFromInternet.length < 30) {
        newsSubject.parameters["endOfList"] = "1";
      }

      newsSubject.state = ProcessState.successful;
      newsSubject.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[News subject] Task successful!");
    } catch (ex) {
      newsSubject.state = ProcessState.failed;
      log("[News subject] Task failed!");
    } finally {
      log("[News subject] End run. Next page: ${newsSubject.parameters["nextPage"] ?? "???"}, current count: ${newsSubject.data.length}");
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
      log("[News student affairs] Task start failed because of timeout. Force this request to continue.");
      return;
    }
    if (newsStudentAffairs.state == ProcessState.running) {
      log("[News student affairs] Task start failed because another same task is running...");
      return;
    }

    if (newsStudentAffairs.parameters["endOfList"] == "1" && fetchType != NewsFetchType.clearCacheAndFirstPage) {
      log("[News student affairs] You're reached end of list. Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.");
      return;
    }

    newsStudentAffairs.state = ProcessState.running;
    notifyListeners();

    log("[News student affairs] Running...");

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
      if (listFromInternet.length < 30) {
        newsStudentAffairs.parameters["endOfList"] = "1";
      }

      newsStudentAffairs.state = ProcessState.successful;
      newsStudentAffairs.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[News student affairs] Task successful!");
    } catch (ex) {
      newsStudentAffairs.state = ProcessState.failed;
      log("[News student affairs] Task failed!");
    } finally {
      log("[News student affairs] Task done! Next page: ${newsStudentAffairs.parameters["nextPage"] ?? "???"}, current count: ${newsStudentAffairs.data.length}");
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
      log("[News examination] Task start failed because of timeout. Force this request to continue.");
      return;
    }
    if (newsExamination.state == ProcessState.running) {
      log("[News examination] Task start failed because another same task is running...");
      return;
    }

    if (newsExamination.parameters["endOfList"] == "1" && fetchType != NewsFetchType.clearCacheAndFirstPage) {
      log("[News examination] You're reached end of list. Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.");
      return;
    }

    newsExamination.state = ProcessState.running;
    notifyListeners();

    log("[News examination] Running...");

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
      if (listFromInternet.length < 30) {
        newsExamination.parameters["endOfList"] = "1";
      }

      newsExamination.state = ProcessState.successful;
      newsExamination.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[News examination] Task successful!");
    } catch (ex) {
      newsExamination.state = ProcessState.failed;
      log("[News examination] Task failed!");
    } finally {
      log("[News examination] Task done! Next page: ${newsExamination.parameters["nextPage"] ?? "???"}, current count: ${newsExamination.data.length}");
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
      log("[News tuition] Task start failed because of timeout. Force this request to continue.");
      return;
    }
    if (newsTuitions.state == ProcessState.running) {
      log("[News tuition] Task start failed because another same task is running...");
      return;
    }

    if (newsTuitions.parameters["endOfList"] == "1" && fetchType != NewsFetchType.clearCacheAndFirstPage) {
      log("[News tuition] You're reached end of list. Set fetchType to 'clearCacheAndFirstPage' to clear cache and start over.");
      return;
    }

    newsTuitions.state = ProcessState.running;
    notifyListeners();

    log("[News tuition] Running...");

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
      if (listFromInternet.length < 30) {
        newsTuitions.parameters["endOfList"] = "1";
      }

      newsTuitions.state = ProcessState.successful;
      newsTuitions.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[News tuition] Task successful!");
    } catch (ex) {
      newsTuitions.state = ProcessState.failed;
      log("[News tuition] Task failed!");
    } finally {
      log("[News tuition] Task done! Next page: ${newsTuitions.parameters["nextPage"] ?? "???"}, current count: ${newsTuitions.data.length}");
      notifyListeners();

      onDone?.call(newsTuitions.state == ProcessState.successful);
    }
  }
}
