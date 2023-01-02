import 'package:dutwrapper/model/news_obj.dart';
import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';

import '../../components/news_details_item_widget.dart';
import '../../components/news_summary_list_widget.dart';
import '../../news_detail/news_detail_view.dart';

class NewsTabGlobal extends StatefulWidget {
  const NewsTabGlobal({
    super.key,
    required this.listNewsGlobal,
    required this.listNewsSubject,
    this.showDetailOnRight = false,
  });

  final List<NewsGlobal> listNewsGlobal;
  final List<NewsSubject> listNewsSubject;
  final bool showDetailOnRight;

  @override
  State<StatefulWidget> createState() => _NewsTabGlobalState();
}

class _NewsTabGlobalState extends State<NewsTabGlobal> {
  NewsGlobal? _selectedNews;
  bool _isNewsSubject = false;

  // 0: News Global, 1: News Subject
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return widget.showDetailOnRight
        ? _splitView(
            context: context,
            listNewsGlobal: widget.listNewsGlobal,
            listNewsSubject: widget.listNewsSubject,
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
            listNewsGlobal: widget.listNewsGlobal,
            listNewsSubject: widget.listNewsSubject,
            onClick: (news, isNewsSubject) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewsDetailView(
                  newsItem: news,
                ),
              ));
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
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
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
            newsList: widget.listNewsGlobal,
            onClick: (news) {
              if (onClick != null) {
                onClick(news, false);
              }
            },
          ),
          NewsSummaryListWidget(
            newsList: widget.listNewsSubject,
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
    return SplitView(
      viewMode: SplitViewMode.Horizontal,
      children: [
        _singleView(
          context: context,
          listNewsGlobal: listNewsGlobal,
          listNewsSubject: listNewsSubject,
          onClick: (news, isNewsSubject) {
            if (onClick != null) {
              onClick(news, isNewsSubject);
            }
          },
        ),
        selectedNews == null
            ? const Center(
                child: Text("Select a news on the left to show its details"),
              )
            : NewsDetailItemWidget(
                newsItem: selectedNews,
                isNewsSubject: false,
              ),
      ],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Text(text),
        ),
      ),
    );
  }
}
