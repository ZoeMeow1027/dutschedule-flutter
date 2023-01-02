import 'package:dutwrapper/model/news_obj.dart';
import 'package:dutwrapper/news.dart';
import 'package:flutter/material.dart';

import 'news_tab.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({
    super.key,
    this.showDetailOnRight = false,
  });

  final bool showDetailOnRight;

  @override
  State<StatefulWidget> createState() {
    return _NewsPageState();
  }
}

class _NewsPageState extends State<NewsPage> {
  final List<NewsGlobal> _newsListGlobal = [];
  final List<NewsSubject> _newsListSubject = [];

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
    return NewsTabGlobal(
      listNewsGlobal: _newsListGlobal,
      listNewsSubject: _newsListSubject,
      showDetailOnRight: widget.showDetailOnRight,
    );
  }
}
