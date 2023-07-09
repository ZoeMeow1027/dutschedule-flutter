import 'package:dutwrapper/model/news_obj.dart';
import 'package:flutter/material.dart';

import 'news_list_item.dart';

class NewsList extends StatefulWidget {
  const NewsList({
    super.key,
    required this.newsList,
    this.color,
    this.onClick,
    this.endListReached,
  });

  final List<NewsGlobal> newsList;
  final Function(NewsGlobal)? onClick;
  final Color? color;
  final Function()? endListReached;

  @override
  State<StatefulWidget> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          color: widget.color,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                widget.newsList.length,
                (index) => NewsListItem(
                  newsItem: widget.newsList[index],
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  onClick: () {
                    if (widget.onClick != null) {
                      widget.onClick!(widget.newsList[index]);
                    }
                  },
                ),
              ),
            ),
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
}
