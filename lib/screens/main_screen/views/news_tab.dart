import 'package:dutwrapper/model/news_obj.dart';
import 'package:dutwrapper/news.dart';
import 'package:flutter/material.dart';

import '../../../utils/get_device_type.dart';
import '../../../utils/launch_url.dart';
import '../../components/news_details_item_widget.dart';
import '../../components/news_summary_list_widget.dart';
import '../../news_detail/news_detail_view.dart';

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

  NewsGlobal? _selectedNews;
  bool _isNewsSubject = false;

  // 0: News Global, 1: News Subject
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentPage);

    News.getNewsGlobal(page: 1).then((value) {
      _newsListGlobal.clear();
      _newsListGlobal.addAll(value);
      setState(() {});
    });
    News.getNewsSubject(page: 1).then((value) {
      _newsListSubject.clear();
      _newsListSubject.addAll(value);
      setState(() {});
    });
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
          _tabSwitchButton(
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
          _tabSwitchButton(
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
          NewsSummaryListWidget(
            newsList: listNewsGlobal,
            onClick: (news) {
              if (onClick != null) {
                onClick(news, false);
              }
            },
          ),
          NewsSummaryListWidget(
            newsList: listNewsSubject,
            onClick: (news) {
              if (onClick != null) {
                onClick(news, true);
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
                  // TODO: Change to dynamic color here!
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
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
                      : NewsDetailItemWidget(
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

  Widget _tabSwitchButton({
    required String text,
    bool isFocus = false,
    Function()? onClick,
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
  }) {
    return Padding(
      padding: padding,
      child: TextButton(
        // TODO: Color here
        style: TextButton.styleFrom(
          backgroundColor: isFocus ? Colors.amberAccent : null,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.amberAccent,
              width: 1.5,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () {
          if (onClick != null) {
            onClick();
          }
        },
        child: Text(text),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
