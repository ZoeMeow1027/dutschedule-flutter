import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import '../../utils/app_localizations.dart';
import '../components/widget_news/news_detail_item.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({
    super.key,
    required this.newsItem,
    this.isNewsSubject = false,
  });

  final NewsGlobal newsItem;
  final bool isNewsSubject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("news_detail_title")),
      ),
      body: SafeArea(
        child: NewsDetailItem(
          newsItem: newsItem,
          isNewsSubject: isNewsSubject,
        ),
      ),
    );
  }
}
