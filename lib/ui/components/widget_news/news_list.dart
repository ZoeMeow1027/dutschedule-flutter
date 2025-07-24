import 'package:collection/collection.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import 'news_end_list_item.dart';
import 'news_list_in_date.dart';

class NewsList extends StatefulWidget {
  const NewsList({
    super.key,
    required this.newsList,
    this.scrollController,
    this.isEndOfList = false,
    this.color,
    this.onClick,
    this.endListReached,
    this.refreshRequested,
    this.isRefreshing = false,
    this.showDateInNewsItem = true,
  });

  final List<NewsCore> newsList;
  final ScrollController? scrollController;
  final bool isEndOfList;
  final Function(NewsCore)? onClick;
  final Color? color;
  final Function()? endListReached;
  final Function()? refreshRequested;
  final bool isRefreshing;
  final bool showDateInNewsItem;

  @override
  State<StatefulWidget> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var tmp = groupBy(widget.newsList, (NewsCore item) => item.datePublished);
    return NotificationListener(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          color: widget.color,
          alignment: Alignment.topCenter,
          child: RefreshIndicator(
            child: tmp.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    controller: widget.scrollController,
                    itemCount: tmp.length + 1,
                    itemBuilder: (context, index) {
                      if (index == tmp.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 7),
                          child: NewsEndListItem(
                            isRefreshing: widget.isRefreshing,
                            isEndOfList: widget.isEndOfList,
                            refreshRequested: () {
                              if (widget.endListReached != null) {
                                widget.endListReached!();
                              }
                            },
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: NewsListInDate(
                            date: tmp.keys.elementAt(index),
                            newsListInDate: tmp[tmp.keys.elementAt(index)] ?? [],
                            color: widget.color,
                            onClick: widget.onClick,
                            showDateInHeader: widget.showDateInNewsItem,
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) => SizedBox(),
                  )
                // If no available news in list
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      widget.isRefreshing
                          // If loading
                          ? CircularProgressIndicator()
                          // If end of list
                          : widget.isEndOfList
                              ? Text(
                                  AppLocalizations.of(context).translate("main_news_nonews_nonews"),
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                )
                              // If no internet
                              : Text(
                                  AppLocalizations.of(context).translate("main_news_nonews_nointernet"),
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                      // TODO: Need information about can't reaching to server here.
                      Spacer(),
                    ],
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
