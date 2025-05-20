import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dutwrapper/enums.dart';
import 'package:dutwrapper/news.dart';
import 'package:dutwrapper/news_object.dart';

import '../model/news_search_history.dart';
import '../model/process_state.dart';
import '../repository/storage_repository.dart';
import 'base_view_model.dart';

class NewsSearchInstance extends BaseViewModel {
  @override
  void initializing() {}

  @override
  void timerAction() {}

  NewsSearchInstance();

  NewsSearchInstance.fromPreviousSettings({required Map<String, dynamic> newsSearchJson}) {
    _fromMap(newsSearchJson);
    _isSettingsInitialized = true;
  }

  bool _isSettingsInitialized = false;

  void _fromMap(Map<String, dynamic> data) {
    newsHistoryList = (data["searchhistory.newshistorylist"] as List<dynamic>? ?? {})
        .map((p) => NewsSearchHistory.fromJson(p))
        .toList()
        .sorted((p, q) => q.lastRequest.compareTo(p.lastRequest))
        .toList();
    _isSettingsInitialized = true;
    notifyListeners();
  }

  Map<String, dynamic> _toMap() {
    return {
      "searchhistory.newshistorylist": newsHistoryList.map((p) => p.toJson()).toList(),
    };
  }

  bool _pendingChanges = false;

  void _settingsChanged() async {
    if (!_isSettingsInitialized) {
      return;
    }
    while (_pendingChanges) {
      await Future.delayed(Duration(milliseconds: 100));
      // return;
    }

    _pendingChanges = true;
    notifyListeners();

    log("[Search History] Modified changes! Saving...");
    await StorageRepository.saveNewsSearchHistory(searchHistory: _toMap());

    _pendingChanges = false;
    notifyListeners();
  }

  int _nextPage = 1;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  NewsType _newsType = NewsType.global;
  NewsType get newsType => _newsType;

  ProcessState _processState = ProcessState.notRunYet;
  ProcessState get processState => _processState;

  NewsSearchMethod _searchMethod = NewsSearchMethod.byTitle;
  NewsSearchMethod get searchMethod => _searchMethod;

  List<NewsGlobal> searchResult = [];
  List<NewsSearchHistory> newsHistoryList = [];

  void resetQueryAndResult() {
    _searchQuery = "";
    _newsType = NewsType.global;
    _searchMethod = NewsSearchMethod.byTitle;
    _processState = ProcessState.notRunYet;
    _nextPage = 1;
    searchResult.clear();
    notifyListeners();
  }

  void changeNewsSearchOption({
    String? query,
    NewsType? newsType,
    NewsSearchMethod? searchMethod,
  }) {
    if (query != null) _searchQuery = query;
    if (newsType != null) _newsType = newsType;
    if (searchMethod != null) _searchMethod = searchMethod;
    notifyListeners();
  }

  Future<void> fetchSearchRun({
    Function()? beforeRun,
    Function()? afterRun,
    bool startOver = false,
  }) async {
    if (processState == ProcessState.running) {
      log("[News Search] Running denied because of another task...");
      return;
    }

    _processState = ProcessState.running;
    notifyListeners();

    beforeRun?.call();

    log("[News Search] Running...");
    try {
      if (_searchQuery.isEmpty) {
        log("[News Search] Running denied because search query is empty...");
        return;
      }
      var page = startOver ? 1 : _nextPage;

      final session = newsType == NewsType.global
          ? await News.getNewsGlobal(
              page: page,
              newsSearchQuery: _searchQuery,
              newsSearchMethod: searchMethod,
            )
          : await News.getNewsSubject(
              page: page,
              newsSearchQuery: _searchQuery,
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

      if (startOver) {
        final searchHistory = NewsSearchHistory(
          query: _searchQuery,
          newsType: newsType,
          searchMethod: searchMethod,
          lastRequest: DateTime.now().toUtc().millisecondsSinceEpoch,
        );
        newsHistoryList.removeWhere((p) => p.equals(searchHistory));
        newsHistoryList.add(searchHistory);
      }
      newsHistoryList.sort((p, q) => q.lastRequest.compareTo(p.lastRequest));

      _processState = ProcessState.successful;
      log("[News Search] Task successful!");
    } catch (ex) {
      _processState = ProcessState.failed;
      log("[News Search] Task failed!");
    } finally {
      log("[News Search] End run.");
      _settingsChanged();
      afterRun?.call();
    }
  }
}
