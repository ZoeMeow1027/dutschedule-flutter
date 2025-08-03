import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class NewsEndListItem extends StatelessWidget {
  const NewsEndListItem({
    super.key,
    this.isRefreshing = false,
    this.isEndOfList = false,
    this.refreshRequested,
  });

  final bool isRefreshing;
  final bool isEndOfList;
  final Function()? refreshRequested;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isEndOfList ? 25 : 60,
      child: InkWell(
        onTap: (!(isRefreshing || isEndOfList)) ? () => refreshRequested?.call() : null,
        child: Center(
          child: isRefreshing
              ? _refreshing(context)
              : isEndOfList
                  ? _endOfList(context)
                  : _clickToRefresh(context),
        ),
      ),
    );
  }

  Widget _clickToRefresh(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              AppLocalizations.of(context).translate("news_endoflist_title"),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _refreshing(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          ),
        ),
        Flexible(
          child: Text(
            AppLocalizations.of(context).translate("news_endoflist_refreshing"),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _endOfList(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            AppLocalizations.of(context).translate("main_news_endoflist"),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
