import 'package:dutwrapper/model/news_obj.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsDetailItemView extends StatelessWidget {
  const NewsDetailItemView({
    super.key,
    required this.newsItem,
    this.isNewsSubject = false,
  });

  final NewsGlobal newsItem;
  final bool isNewsSubject;

  @override
  Widget build(BuildContext context) {
    var dateStr = DateFormat("dd/MM/yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(newsItem.date));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsItem.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                "News date: $dateStr",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                ),
              ),
            ),
            const Divider(
              height: 10,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                newsItem.contentString,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
