import 'package:collection/collection.dart';
import 'package:dutschedule/ui/components/news_widget/news_list_in_date.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import 'news_end_list_item.dart';

class NewsList extends StatefulWidget {
  const NewsList({
    super.key,
    required this.newsList,
    this.scrollController,
    this.color,
    this.onClick,
    this.endListReached,
    this.refreshRequested,
    this.isRefreshing = false,
  });

  final List<NewsGlobal> newsList;
  final ScrollController? scrollController;
  final Function(NewsGlobal)? onClick;
  final Color? color;
  final Function()? endListReached;
  final Function()? refreshRequested;
  final bool isRefreshing;

  @override
  State<StatefulWidget> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var tmp = groupBy(widget.newsList, (NewsGlobal item) => item.date);
    return NotificationListener(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          color: widget.color,
          alignment: Alignment.topCenter,
          child: RefreshIndicator(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: tmp.length + 1,
              itemBuilder: (context, index) {
                if (index == tmp.length) {
                  return NewsEndListItem(
                    isRefreshing: widget.isRefreshing,
                    refreshRequested: () {
                      if (widget.endListReached != null) {
                        widget.endListReached!();
                      }
                    },
                  );
                } else {
                  return NewsListInDate(
                    date: tmp.keys.elementAt(index),
                    newsListInDate: tmp[tmp.keys.elementAt(index)] ?? [],
                    color: widget.color,
                    onClick: widget.onClick,
                  );
                }
              },
            ),
            onRefresh: () async {
              if (widget.refreshRequested != null) {
                await widget.refreshRequested!();
              }
            },
          ),
        ),
      ),
      onNotification: (notificationInfo) {
        if (notificationInfo is ScrollEndNotification) {
          // print("Bottom: " + notificationInfo.metrics.extentAfter.toString());
          if (notificationInfo.metrics.extentAfter < 128) {
            if (widget.endListReached != null) {
              widget.endListReached!();
            }
          }
        }
        return true;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
