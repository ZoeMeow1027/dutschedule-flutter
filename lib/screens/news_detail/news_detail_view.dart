import 'package:dutwrapper/model/news_obj.dart';
import 'package:flutter/material.dart';

import '../../utils/launch_url.dart';
import '../components/news_details_item_widget.dart';

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
      body: NewsDetailItemWidget(
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
