import 'package:collection/collection.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
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
                // If have news list (not empty)
                ? _hasNews(
                    context: context,
                    newsList: tmp,
                    color: widget.color,
                    showDateInNewsItem: widget.showDateInNewsItem,
                    scrollController: widget.scrollController,
                    onClick: widget.onClick,
                    isRefreshing: widget.isRefreshing,
                    isEndOfList: widget.isEndOfList,
                    endOfListReached: widget.endListReached,
                  )
                // If no available news in list
                : widget.isRefreshing
                    ? _noNewsLoading()
                    : widget.isEndOfList
                        ? _noNewsEndOfList(context: context)
                        : _noNewsNoInternet(context: context),
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

  Widget _hasNews({
    required BuildContext context,
    required Map<int, List<NewsCore>> newsList,
    Color? color,
    bool showDateInNewsItem = false,
    ScrollController? scrollController,
    Function(NewsCore)? onClick,
    bool isRefreshing = false,
    bool isEndOfList = false,
    Function()? endOfListReached,
  }) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15),
      controller: scrollController,
      itemCount: newsList.length + 1,
      itemBuilder: (context, index) {
        if (index == newsList.length) {
          return Padding(
            padding: EdgeInsets.only(top: 7),
            child: NewsEndListItem(
              isRefreshing: isRefreshing,
              isEndOfList: isEndOfList,
              refreshRequested: () {
                endOfListReached?.call();
              },
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(top: 10),
            child: NewsListInDate(
              date: newsList.keys.elementAt(index),
              newsListInDate: newsList[newsList.keys.elementAt(index)] ?? [],
              color: color,
              onClick: onClick,
              showDateInHeader: showDateInNewsItem,
            ),
          );
        }
      },
      separatorBuilder: (context, index) => SizedBox(),
    );
  }

  Widget _noNewsLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _noNewsEndOfList({
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Text(
          AppLocalizations.of(context).translate("main_news_nonews_nonews"),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _noNewsNoInternet({
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Text(
          AppLocalizations.of(context).translate("main_news_nonews_nointernet"),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
