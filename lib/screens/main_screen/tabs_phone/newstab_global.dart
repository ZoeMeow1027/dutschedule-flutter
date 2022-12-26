import 'package:dutwrapper/model/news_obj.dart';
import 'package:flutter/material.dart';

import '../../components/news_summary_list_widget.dart';

class NewsTabGlobal extends StatelessWidget {
  const NewsTabGlobal({super.key, required this.newsList});

  final List<NewsGlobal> newsList;

  @override
  Widget build(BuildContext context) {
    return NewsSummaryListWidget(
      newsList: newsList,
    );
  }
}
