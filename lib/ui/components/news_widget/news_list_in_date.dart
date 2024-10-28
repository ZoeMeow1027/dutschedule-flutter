import 'package:dutwrapper/news_object.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'news_list_item.dart';

class NewsListInDate extends StatelessWidget {
  const NewsListInDate({
    super.key,
    required this.date,
    required this.newsListInDate,
    this.color,
    this.onClick,
  });

  final int date;
  final List<NewsGlobal> newsListInDate;
  final Color? color;
  final Function(NewsGlobal)? onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          newsListInDate.length + 1,
          (index) {
            if (index == 0) {
              return Text(
                DateFormat("EE, dd/MM/yyyy")
                    .format(DateTime.fromMillisecondsSinceEpoch(date)),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              );
            }
            return NewsListItem(
              showDate: false,
              newsItem: newsListInDate[index - 1],
              padding: const EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 10,
              ),
              onClick: () {
                if (onClick != null) {
                  onClick!(newsListInDate[index - 1]);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
