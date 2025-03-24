import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import '../model/enum/news_tab_location.dart';
import 'base_view_model.dart';

class MainViewModel extends BaseViewModel {
  @override
  void initializing() {}

  @override
  void timerAction() {}

  // News page
  NewsTabLocation newsCurrentPage = NewsTabLocation.globalNews;
  final PageController newsPageController = PageController(
    initialPage: NewsTabLocation.globalNews.value,
  );

  void setNewsCurrentPage({required NewsTabLocation selectedPage}) {
    newsCurrentPage = selectedPage;
    newsPageController.animateToPage(
      selectedPage.value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linearToEaseOut,
    );
    notifyListeners();
  }

  NewsGlobal? newsSelected;
  bool newsSelectedIsSubject = false;

  void setNewsSelected({
    NewsGlobal? news,
    bool isNewsSubject = false,
  }) {
    newsSelected = news;
    newsSelectedIsSubject = isNewsSubject;
    notifyListeners();
  }
  // End news page

  // Account page
  Map<String, Object> accountParameter = {};

  void setAccountValue(String key, Object value) {
    accountParameter[key] = value;
    notifyListeners();
  }
  // End account page
}
