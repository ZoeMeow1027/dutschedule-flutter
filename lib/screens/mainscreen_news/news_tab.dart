import 'package:dutwrapper/model/news_global.dart';
import 'package:dutwrapper/model/news_subject.dart';
import 'package:dutwrapper/news.dart';
import 'package:flutter/material.dart';

import '../../components/news_widget/news_detail_item.dart';
import '../../utils/theme_tools.dart';
import '../../components/news_widget/news_list.dart';
import '../../components/tab_switch_button.dart';
import '../../utils/get_device_type.dart';
import '../../utils/launch_url.dart';
import '../news_detail/news_detail_view.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewsTabState();
  }
}

class _NewsTabState extends State<NewsTab>
    with AutomaticKeepAliveClientMixin<NewsTab> {
  final List<NewsGlobal> _newsListGlobal = [];
  final List<NewsSubject> _newsListSubject = [];
  int _newsGlobalPage = 1;
  int _newsSubjectPage = 1;

  void _loadNewsGlobal({bool forceNew = false}) {
    if (forceNew) {
      _newsGlobalPage = 1;
    }
    News.getNewsGlobal(page: _newsGlobalPage).then((value) {
      if (forceNew) {
        _newsListGlobal.clear();
      }
      _newsListGlobal.addAll(value);
      _newsGlobalPage += 1;
      setState(() {});
    });
  }

  void _loadNewsSubject({bool forceNew = false}) {
    if (forceNew) {
      _newsSubjectPage = 1;
    }
    News.getNewsSubject(page: _newsSubjectPage).then((value) {
      if (forceNew) {
        _newsListSubject.clear();
      }
      _newsListSubject.addAll(value);
      _newsSubjectPage += 1;
      setState(() {});
    });
  }

  NewsGlobal? _selectedNews;
  bool _isNewsSubject = false;

  // 0: News Global, 1: News Subject
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentPage);

    _loadNewsGlobal(forceNew: true);
    _loadNewsSubject(forceNew: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return getDeviceType(context).value > DeviceType.tablet.value
        ? _splitView(
            context: context,
            listNewsGlobal: _newsListGlobal,
            listNewsSubject: _newsListSubject,
            selectedNews: _selectedNews,
            onClick: (news, isNewsSubject) {
              setState(() {
                _selectedNews = news;
                _isNewsSubject = isNewsSubject;
              });
            },
          )
        : _singleView(
            context: context,
            listNewsGlobal: _newsListGlobal,
            listNewsSubject: _newsListSubject,
            onClick: (news, isNewsSubject) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailView(
                    newsItem: news,
                    isNewsSubject: isNewsSubject,
                  ),
                ),
              );
            },
          );
  }

  Widget _singleView({
    required BuildContext context,
    required List<NewsGlobal> listNewsGlobal,
    required List<NewsSubject> listNewsSubject,
    Function(NewsGlobal, bool)? onClick,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        actions: [
          TabSwitchButton(
            text: "Global",
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
            isFocus: _currentPage == 0,
            onClick: () {
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
              );
            },
          ),
          TabSwitchButton(
            text: "Subject",
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 3),
            isFocus: _currentPage == 1,
            onClick: () {
              _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const AlwaysScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          NewsList(
            newsList: listNewsGlobal,
            onClick: (news) {
              if (onClick != null) {
                onClick(news, false);
              }
            },
            endListReached: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Reloading new..."),
              ));
              _loadNewsGlobal();
            },
          ),
          NewsList(
            newsList: listNewsSubject,
            onClick: (news) {
              if (onClick != null) {
                onClick(news, true);
              }
            },
            endListReached: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Reloading new..."),
              ));
              _loadNewsSubject();
            },
          ),
        ],
      ),
    );
  }

  Widget _splitView({
    required BuildContext context,
    required List<NewsGlobal> listNewsGlobal,
    required List<NewsSubject> listNewsSubject,
    Function(NewsGlobal, bool)? onClick,
    NewsGlobal? selectedNews,
  }) {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 450,
            child: _singleView(
              context: context,
              listNewsGlobal: listNewsGlobal,
              listNewsSubject: listNewsSubject,
              onClick: (news, isNewsSubject) {
                if (onClick != null) {
                  onClick(news, isNewsSubject);
                }
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, right: 10, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeTool.isDarkMode(context)
                      ? Theme.of(context).dialogBackgroundColor
                      : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeTool.isDarkMode(context)
                          ? Color.fromARGB(255, 48, 48, 48).withOpacity(0.5)
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: selectedNews == null
                      ? const Center(
                          child: Text(
                              "Select a news on the left to show its details"),
                        )
                      : NewsDetailItem(
                          newsItem: selectedNews,
                          isNewsSubject: _isNewsSubject,
                          onClickUrl: (url) {
                            launchOwnUrl(
                              url,
                              onFailed: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("We can't open links for you."),
                                ));
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
