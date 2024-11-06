import 'dart:developer';

import 'package:dutwrapper/enums.dart';
import 'package:dutwrapper/news.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import '../model/news_search_history.dart';
import '../model/process_state.dart';
import 'base_view_model.dart';

class NewsSearchInstance extends ChangeNotifier with BaseViewModel {
  @override
  Future<void> initializing() async {}

  var newsSearchQueryTextControl = TextEditingController();

  int _nextPage = 1;
  String searchQuery = "";
  String searchQueryTemp = "";
  int _searchLastRequest = 0;
  NewsType newsType = NewsType.global;
  ProcessState searchProcessState = ProcessState.notRunYet;
  NewsSearchMethod searchMethod = NewsSearchMethod.byTitle;
  List<NewsGlobal> searchResult = [];
  List<NewsSearchHistory> newsHistoryList = [];

  void resetQueryAndResult() {
    searchQuery = "";
    newsType = NewsType.global;
    searchMethod = NewsSearchMethod.byTitle;
    _nextPage = 1;
    searchResult.clear();
    newsSearchQueryTextControl.clear();
    notifyListeners();
  }

  void changeNewsSearchOption({
    String? query,
    NewsType? newsType,
    NewsSearchMethod? searchMethod,
  }) {
    if (query != null) searchQueryTemp = query;
    if (newsType != null) this.newsType = newsType;
    if (searchMethod != null) this.searchMethod = searchMethod;
    notifyListeners();
  }

  Future<void> fetchSearchRun({
    Function()? beforeRun,
    Function()? afterRun,
    bool startOver = false,
  }) async {
    if (searchProcessState == ProcessState.running) {
      log("[Search history] Running denied because of another task...");
      return;
    }

    searchProcessState = ProcessState.running;
    notifyListeners();
    beforeRun?.call();

    log("[Search history] Running...");
    try {
      if (searchQueryTemp.isNotEmpty) {
        searchQuery = searchQueryTemp;
        searchQueryTemp = "";
      }
      if (searchQuery.isEmpty) {
        log("[Search history] Running denied because search query is empty...");
        return;
      }
      var page = startOver ? 1 : _nextPage;

      final session = newsType == NewsType.global
          ? await News.getNewsGlobal(
              page: page,
              newsSearchQuery: searchQuery,
              newsSearchMethod: searchMethod,
            )
          : await News.getNewsSubject(
              page: page,
              newsSearchQuery: searchQuery,
              newsSearchMethod: searchMethod,
            );

      if (startOver) {
        searchResult.clear();
      }
      searchResult.addAll(session);

      if (startOver) {
        _nextPage = 2;
      } else {
        _nextPage += 1;
      }

      final searchHistory = NewsSearchHistory(
        query: searchQuery,
        newsType: newsType,
        searchMethod: searchMethod,
      );
      if (!newsHistoryList.any((p) => p.equals(searchHistory))) {
        newsHistoryList.add(searchHistory);
      }

      searchProcessState = ProcessState.successful;
      log("[Search history] Running successful!");
    } catch (ex) {
      searchProcessState = ProcessState.failed;
      log("[Search history] Running failed!");
    } finally {
      _searchLastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Search history] End run.");
      notifyListeners();
      afterRun?.call();
    }
  }
}
