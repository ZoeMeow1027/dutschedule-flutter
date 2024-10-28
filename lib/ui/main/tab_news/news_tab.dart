import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:dutwrapper/news.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import '../../../utils/theme_tools.dart';
import '../../components/news_widget/news_detail_item.dart';
import '../../components/news_widget/news_list.dart';
import '../../../utils/get_device_type.dart';
import '../../../utils/launch_url.dart';
import '../../news_detail/news_detail_view.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewsTabState();
  }
}

enum NewsTabLocation {
  globalNews(0),
  subjectNews(1);

  final int value;

  const NewsTabLocation(this.value);
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

  NewsTabLocation _currentPage = NewsTabLocation.globalNews;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: NewsTabLocation.globalNews.value,
    );

    _loadNewsGlobal(forceNew: true);
    _loadNewsSubject(forceNew: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return context.getDeviceType().value > DeviceType.tablet.value
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
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
          )
        ],
      ),
      body: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const AlwaysScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              switch (page) {
                case 0:
                  _currentPage = NewsTabLocation.globalNews;
                  break;
                case 1:
                  _currentPage = NewsTabLocation.subjectNews;
                  break;
                default:
                  break;
              }
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
                  context.clearSnackBars();
                  context.showSnackBar(const SnackBar(
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
                  context.clearSnackBars();
                  context.showSnackBar(const SnackBar(
                    content: Text(
                        "We ran into a issue prevent you refreshing news. Please try again or check your internet connection."),
                  ));
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: ((_currentPage == NewsTabLocation.globalNews &&
                      _isNewsGlobalRefreshing) ||
                  (_currentPage == NewsTabLocation.subjectNews &&
                      _isNewsSubjectRefreshing))
              ? SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(),
                )
              : const Icon(Icons.refresh),
          onPressed: () async {
            try {
              switch (_currentPage) {
                case NewsTabLocation.globalNews:
                  await _loadNewsGlobal(forceNew: true);
                  break;
                case NewsTabLocation.subjectNews:
                  await _loadNewsSubject(forceNew: true);
                  break;
              }
            } catch (ex) {
              context.clearSnackBars();
              context.showSnackBar(const SnackBar(
                content: Text(
                    "We ran into a issue prevent you refreshing news. Please try again or check your internet connection."),
              ));
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(right: 60),
          child: BottomAppBar(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SegmentedButton<NewsTabLocation>(
                  segments: const [
                    ButtonSegment(
                      value: NewsTabLocation.globalNews,
                      label: Text("Global"),
                    ),
                    ButtonSegment(
                      value: NewsTabLocation.subjectNews,
                      label: Text("Subject"),
                    ),
                  ],
                  selected: <NewsTabLocation>{_currentPage},
                  onSelectionChanged: (selected) {
                    setState(() {
                      // By default there is only a single segment that can be
                      // selected at one time, so its value is always the first
                      // item in the selected set.
                      _currentPage = selected.first;

                      _pageController.animateToPage(
                        _currentPage.value,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.fastOutSlowIn,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ),
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
                      ? Theme.of(context).dialogTheme.backgroundColor
                      : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeTool.isDarkMode(context)
                          ? const Color.fromARGB(255, 48, 48, 48)
                              .withValues(alpha: 0.5)
                          : Colors.grey.withValues(alpha: 0.5),
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
                                context.clearSnackBars();
                                context.showSnackBar(const SnackBar(
                                  content: Text(
                                      "We ran into a issue prevent you refreshing news. Please try again or check your internet connection."),
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
