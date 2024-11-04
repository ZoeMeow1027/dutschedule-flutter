import 'dart:developer';

import 'package:dutwrapper/news.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import '../model/process_state.dart';
import '../model/variable_state.dart';
import 'base_view_model.dart';

enum NewsFetchType {
  nextPage,
  firstPage,
  clearCacheAndFirstPage,
}

class NewsCacheInstance extends ChangeNotifier with BaseViewModel {
  @override
  Future<void> initializing() async {
    fetchGlobalNews();
    fetchSubjectNews();
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

  Future<void> fetchGlobalNews({
    NewsFetchType fetchType = NewsFetchType.nextPage,
    bool forceRequest = false,
    Function()? onDone,
  }) async {
    if (!newsGlobal.isSuccessfulRequestExpired() && !forceRequest) {
      log("News global: Running denied because of timeout. Force this request to continue.");
      return;
    }
    if (newsGlobal.state == ProcessState.running) {
      log("News global: Running denied because of running...");
      return;
    }

    newsGlobal.state = ProcessState.running;
    notifyListeners();

    log("News global: Running...");

    List<NewsGlobal> latestNews = [];
    try {
      var listFromInternet = await News.getNewsGlobal(
        page: fetchType == NewsFetchType.nextPage
            ? (int.tryParse(newsGlobal.parameters["nextPage"] ?? "") ?? 1)
            : 1,
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
            newsGlobal.data
                .firstWhere((p) => p.date == item.date && p.title == item.title)
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
              ((int.tryParse(newsGlobal.parameters["nextPage"] ?? "") ?? 1) + 1)
                  .toString();
          break;
        // Just keep current
        case NewsFetchType.firstPage:
          newsGlobal.parameters["nextPage"] =
              (int.tryParse(newsGlobal.parameters["nextPage"] ?? "") ?? 1)
                  .toString();
          break;
        // Set to 2
        case NewsFetchType.clearCacheAndFirstPage:
          newsGlobal.parameters["nextPage"] = 2.toString();
          break;
      }

      newsGlobal.state = ProcessState.successful;
      newsGlobal.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("News global: Running successful!");
    } catch (ex) {
      newsGlobal.state = ProcessState.failed;
      log("News global: Running failed!");
    } finally {
      log("News global: Done running! Next page: ${newsGlobal.parameters["nextPage"] ?? "???"}, current count: ${newsGlobal.data.length}");
      notifyListeners();
      onDone?.call();
    }
  }

  Future<void> fetchSubjectNews({
    NewsFetchType fetchType = NewsFetchType.nextPage,
    bool forceRequest = false,
    Function()? onDone,
  }) async {
    if (!newsSubject.isSuccessfulRequestExpired() && !forceRequest) {
      log("News subject: Running denied because of timeout. Force this request to continue.");
      return;
    }
    if (newsSubject.state == ProcessState.running) {
      log("News subject: Running denied because of running...");
      return;
    }

    newsSubject.state = ProcessState.running;
    notifyListeners();

    log("News subject: Running...");

    List<NewsSubject> latestNews = [];
    try {
      var listFromInternet = await News.getNewsSubject(
        page: fetchType == NewsFetchType.nextPage
            ? (int.tryParse(newsSubject.parameters["nextPage"] ?? "") ?? 1)
            : 1,
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
              ((int.tryParse(newsSubject.parameters["nextPage"] ?? "") ?? 1) +
                      1)
                  .toString();
          break;
        // Just keep current
        case NewsFetchType.firstPage:
          newsSubject.parameters["nextPage"] =
              (int.tryParse(newsSubject.parameters["nextPage"] ?? "") ?? 1)
                  .toString();
          break;
        // Set to 2
        case NewsFetchType.clearCacheAndFirstPage:
          newsSubject.parameters["nextPage"] = 2.toString();
          break;
      }

      newsSubject.state = ProcessState.successful;
      newsSubject.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("News subject: Running successful!");
    } catch (ex) {
      newsSubject.state = ProcessState.failed;
      log("News subject: Running failed!");
    } finally {
      log("News subject: End run. Next page: ${newsSubject.parameters["nextPage"] ?? "???"}, current count: ${newsSubject.data.length}");
      notifyListeners();
      onDone?.call();
    }
  }
}
