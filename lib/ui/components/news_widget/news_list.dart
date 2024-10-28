import 'package:collection/collection.dart';
import 'package:dutschedule/ui/components/news_widget/news_list_in_date.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import 'news_end_list_item.dart';

class NewsList extends StatelessWidget {
  const NewsList({
    super.key,
    required this.newsList,
    this.color,
    this.onClick,
    this.endListReached,
    this.refreshRequested,
    this.isRefreshing = false,
  });

  final List<NewsGlobal> newsList;
  final Function(NewsGlobal)? onClick;
  final Color? color;
  final Function()? endListReached;
  final Function()? refreshRequested;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    var tmp = groupBy(newsList, (NewsGlobal item) => item.date);
    return NotificationListener(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          color: color,
          alignment: Alignment.topCenter,
          child: RefreshIndicator(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: List.generate(
                      tmp.length,
                      (index) => NewsListInDate(
                        date: tmp.keys.elementAt(index),
                        newsListInDate: tmp[tmp.keys.elementAt(index)] ?? [],
                        color: color,
                        onClick: onClick,
                      ),
                    ),
                  ),
                  NewsEndListItem(
                    isRefreshing: isRefreshing,
                    refreshRequested: () {
                      if (endListReached != null) {
                        endListReached!();
                      }
                    },
                  ),
                ],
              ),
            ),
            onRefresh: () async {
              if (refreshRequested != null) {
                await refreshRequested!();
              }
            },
          ),
        ),
      ),
      onNotification: (notificationInfo) {
        if (notificationInfo is ScrollEndNotification) {
          // print("Bottom: " + notificationInfo.metrics.extentAfter.toString());
          if (notificationInfo.metrics.extentAfter < 128) {
            if (endListReached != null) {
              endListReached!();
            }
          }
        }
        return true;
      },
    );
  }
}
