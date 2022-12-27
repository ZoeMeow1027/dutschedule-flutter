import 'package:dutwrapper/model/news_obj.dart';
import 'package:dutwrapper/news.dart';
import 'package:flutter/material.dart';

import 'newstab_global.dart';
import 'newstab_subject.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewsPageState();
  }
}

class _NewsPageState extends State<NewsPage> {
  final List<NewsGlobal> _newsListGlobal = [];
  final List<NewsSubject> _newsListSubject = [];
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        actions: [
          _tabSwitchButton(
            text: "Global",
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
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
            padding: const EdgeInsets.symmetric(vertical: 7),
            isFocus: _currentPage == 1,
            onClick: () {
              _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
              );
            },
          ),
          const Padding(padding: EdgeInsets.only(right: 10)),
        ],
      ),
      body: PageView(
        controller: _pageController,
        // physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) => setState(() {
          setState(() {
            _currentPage = page;
          });
        }),
        children: [
          NewsTabGlobal(newsList: _newsListGlobal),
          NewsTabSubject(newsList: _newsListSubject),
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
    return Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(text),
        ),
      ),
    );
  }
}
