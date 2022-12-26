import 'package:dutwrapper/model/news_obj.dart';
import 'package:flutter/material.dart';

import '../../components/news_summary_list_widget.dart';

class NewsTabSubject extends StatelessWidget {
  const NewsTabSubject({super.key, required this.newsList});

  final List<NewsSubject> newsList;

  @override
  Widget build(BuildContext context) {
    return NewsSummaryListWidget(
      newsList: newsList,
    );
  }
}
