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
  }

  VariableListState<NewsGlobal> newsGlobal = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1"},
  );

  VariableListState<NewsSubject> newsSubject = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1"},
  );

  VariableListState<NewsGlobal> newsStudentAffairs = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1"},
  );

  VariableListState<NewsGlobal> newsExamination = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1"},
  );

  VariableListState<NewsGlobal> newsTuitions = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {"nextPage": "1"},
  );

  Future<void> fetchGlobalNews({
    NewsFetchType fetchType = NewsFetchType.nextPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    if (!newsGlobal.isSuccessfulRequestExpired() && !forceRequest) {
      log("[News global] Running denied because of timeout. Force this request to continue.");
      return;
    }
    if (newsGlobal.state == ProcessState.running) {
      log("[News global] Running denied because of running...");
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

      newsGlobal.state = ProcessState.successful;
      newsGlobal.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[News global] Running successful!");
    } catch (ex) {
      newsGlobal.state = ProcessState.failed;
      log("[News global] Running failed!");
    } finally {
      log("[News global] Done running! Next page: ${newsGlobal.parameters["nextPage"] ?? "???"}, current count: ${newsGlobal.data.length}");
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
      log("[News subject] Running denied because of timeout. Force this request to continue.");
      return;
    }
    if (newsSubject.state == ProcessState.running) {
      log("[News subject] Running denied because of running...");
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

      newsSubject.state = ProcessState.successful;
      newsSubject.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[News subject] Running successful!");
    } catch (ex) {
      newsSubject.state = ProcessState.failed;
      log("[News subject] Running failed!");
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
      log("[News student affairs] Running denied because of timeout. Force this request to continue.");
      return;
    }
    if (newsStudentAffairs.state == ProcessState.running) {
      log("[News student affairs] Running denied because of running...");
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

      newsStudentAffairs.state = ProcessState.successful;
      newsStudentAffairs.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[News student affairs] Running successful!");
    } catch (ex) {
      newsStudentAffairs.state = ProcessState.failed;
      log("[News student affairs] Running failed!");
    } finally {
      log("[News student affairs] Done running! Next page: ${newsStudentAffairs.parameters["nextPage"] ?? "???"}, current count: ${newsStudentAffairs.data.length}");
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
      log("[News examination] Running denied because of timeout. Force this request to continue.");
      return;
    }
    if (newsExamination.state == ProcessState.running) {
      log("[News examination] Running denied because of running...");
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

      newsExamination.state = ProcessState.successful;
      newsExamination.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[News examination] Running successful!");
    } catch (ex) {
      newsExamination.state = ProcessState.failed;
      log("[News examination] Running failed!");
    } finally {
      log("[News examination] Done running! Next page: ${newsExamination.parameters["nextPage"] ?? "???"}, current count: ${newsExamination.data.length}");
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
      log("[News tuition] Running denied because of timeout. Force this request to continue.");
      return;
    }
    if (newsTuitions.state == ProcessState.running) {
      log("[News tuition] Running denied because of running...");
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

      newsTuitions.state = ProcessState.successful;
      newsTuitions.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[News tuition] Running successful!");
    } catch (ex) {
      newsTuitions.state = ProcessState.failed;
      log("[News tuition] Running failed!");
    } finally {
      log("[News tuition] Done running! Next page: ${newsTuitions.parameters["nextPage"] ?? "???"}, current count: ${newsTuitions.data.length}");
      notifyListeners();
      onDone?.call(newsTuitions.state == ProcessState.successful);
    }
  }
}
