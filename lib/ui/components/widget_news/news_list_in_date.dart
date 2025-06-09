import 'package:collection/collection.dart';
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
        spacing: 3,
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
    globalList.forEachIndexed((index, news) {
      list.add(NewsListItem(
        showDate: !showDateInHeader,
        newsItem: news,
        onClick: () {
          if (onClick != null) {
            onClick!(news);
          }
        },
        shouldRadiusOnTop: index == 0,
        shouldRadiusOnBottom: index == (globalList.length - 1),
      ));
    });
    // list.addAll(globalList.map((e) {
    //   return NewsListItem(
    //     showDate: !showDateInHeader,
    //     newsItem: e,
    //     onClick: () {
    //       if (onClick != null) {
    //         onClick!(e);
    //       }
    //     },
    //   );
    // }).toList());

    return list;
  }
}
