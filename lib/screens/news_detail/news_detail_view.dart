import 'package:dutwrapper/model/news_global.dart';
import 'package:flutter/material.dart';

import '../../components/news_widget/news_detail_item.dart';
import '../../utils/launch_url.dart';

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
        title: const Text("News Detail"),
      ),
      body: NewsDetailItem(
        newsItem: newsItem,
        isNewsSubject: isNewsSubject,
        onClickUrl: (url) {
          launchOwnUrl(
            url,
            onFailed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("We can't open links for you."),
              ));
            },
          );
        },
      ),
    );
  }
}
