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
    this.showDateInHeader = true,
  });

  final int date;
  final List<NewsGlobal> newsListInDate;
  final Color? color;
  final Function(NewsGlobal)? onClick;
  final bool showDateInHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 7, bottom: showDateInHeader ? 0 : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _listWithDate(context, newsListInDate),
      ),
    );
  }

  List<Widget> _listWithDate(BuildContext context, List<NewsGlobal> globalList) {
    List<Widget> list = [
      Text(
        DateFormat("EE, dd/MM/yyyy", Localizations.localeOf(context).toString()).format(
          DateTime.fromMillisecondsSinceEpoch(date),
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
      ),
    ];
    list.addAll(globalList.map((e) {
      return NewsListItem(
        showDate: !showDateInHeader,
        newsItem: e,
        padding: const EdgeInsets.symmetric(
          vertical: 1,
          horizontal: 10,
        ),
        onClick: () {
          if (onClick != null) {
            onClick!(e);
          }
        },
      );
    }).toList(
      growable: false,
    ));

    return list;
  }
}
