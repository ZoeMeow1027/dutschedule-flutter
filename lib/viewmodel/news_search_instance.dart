import 'dart:developer';

import 'package:dutwrapper/enums.dart';
import 'package:dutwrapper/news.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import '../model/process_state.dart';
import '../model/variable_state.dart';
import 'base_view_model.dart';

class NewsSearchInstance extends ChangeNotifier with BaseViewModel {
  @override
  Future<void> initializing() async {}

  var newsSearchQueryTextControl = TextEditingController();

  int _nextPage = 1;
  String searchQuery = "";
  String searchQueryTemp = "";
  NewsType newsType = NewsType.global;
  NewsSearchMethod searchMethod = NewsSearchMethod.byTitle;
  VariableListState<NewsGlobal> searchResult = VariableListState<NewsGlobal>();

  void resetQuery() {
    searchQuery = "";
    newsType = NewsType.global;
    searchMethod = NewsSearchMethod.byTitle;
    _nextPage = 1;
    notifyListeners();
  }

  void resetQueryAndResult() {
    resetQuery();
    searchResult.resetValue();
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

  void resetNewsSearchOption() {
    resetQuery();
    newsSearchQueryTextControl.clear();
    notifyListeners();
  }

  Future<void> fetchSearchRun({
    Function()? beforeRun,
    Function()? afterRun,
    bool startOver = false,
  }) async {
    if (searchResult.state == ProcessState.running) {
      log("[Search history] Running denied because of another task...");
      return;
    }

    searchResult.state = ProcessState.running;
    notifyListeners();
    beforeRun?.call();

    log("[Search history] Running...");
    try {
      searchQuery = searchQueryTemp;
      searchQueryTemp = "";
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
        searchResult.data.clear();
      }
      searchResult.data.addAll(session);

      if (startOver) {
        _nextPage = 2;
      } else {
        _nextPage += 1;
      }

      searchResult.state = ProcessState.successful;
      log("[Search history] Running successful!");
    } catch (ex) {
      searchResult.state = ProcessState.failed;
      log("[Search history] Running failed!");
    } finally {
      searchResult.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Search history] End run.");
      notifyListeners();
      afterRun?.call();
    }
  }
}
