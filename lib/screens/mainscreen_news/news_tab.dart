import 'package:dutwrapper/model/news_obj.dart';
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
  bool _isNewsGlobalRefreshing = false;
  bool _isNewsSubjectRefreshing = false;

  Future<void> _loadNewsGlobal({bool forceNew = false}) async {
    if (_isNewsGlobalRefreshing) {
      return;
    }
    setState(() {
      _isNewsGlobalRefreshing = true;
    });

    try {
      var data = await News.getNewsGlobal(page: forceNew ? 1 : _newsGlobalPage);
      if (forceNew) {
        _newsListGlobal.clear();
      }
      _newsListGlobal.addAll(data);
      setState(() {
        _newsGlobalPage = forceNew ? 2 : _newsGlobalPage + 1;
      });
    } catch (ex) {
      rethrow;
    } finally {
      setState(() {
        _isNewsGlobalRefreshing = false;
      });
    }
  }

  Future<void> _loadNewsSubject({bool forceNew = false}) async {
    if (_isNewsSubjectRefreshing) {
      return;
    }
    setState(() {
      _isNewsSubjectRefreshing = true;
    });

    try {
      var data =
          await News.getNewsSubject(page: forceNew ? 1 : _newsSubjectPage);
      if (forceNew) {
        _newsListSubject.clear();
      }
      _newsListSubject.addAll(data);
      setState(() {
        _newsSubjectPage = forceNew ? 2 : _newsSubjectPage + 1;
      });
    } catch (ex) {
      rethrow;
    } finally {
      setState(() {
        _isNewsSubjectRefreshing = false;
      });
    }
  }

  NewsGlobal? _selectedNews;
  bool _isNewsSubject = false;

  // 0: News Global, 1: News Subject
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() async {
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
            isRefreshing: _isNewsGlobalRefreshing,
            onClick: (news) {
              if (onClick != null) {
                onClick(news, false);
              }
            },
            endListReached: () {
              _loadNewsGlobal();
            },
            refreshRequested: () async {
              try {
                await _loadNewsGlobal(forceNew: true);
              } catch (ex) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "We ran into a issue prevent you refreshing news. Please try again or check your internet connection."),
                ));
              }
            },
          ),
          NewsList(
            newsList: listNewsSubject,
            isRefreshing: _isNewsSubjectRefreshing,
            onClick: (news) {
              if (onClick != null) {
                onClick(news, true);
              }
            },
            endListReached: () {
              _loadNewsSubject();
            },
            refreshRequested: () async {
              try {
                await _loadNewsSubject(forceNew: true);
              } catch (ex) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "We ran into a issue prevent you refreshing news. Please try again or check your internet connection."),
                ));
              }
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
                          ? const Color.fromARGB(255, 48, 48, 48)
                              .withOpacity(0.5)
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
