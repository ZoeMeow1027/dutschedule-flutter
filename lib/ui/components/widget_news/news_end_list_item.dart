import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';

class NewsEndListItem extends StatelessWidget {
  const NewsEndListItem({
    super.key,
    this.isRefreshing = false,
    this.refreshRequested,
  });
  final bool isRefreshing;
  final Function()? refreshRequested;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: InkWell(
        onTap: isRefreshing
            ? null
            : () {
                if (refreshRequested != null) {
                  refreshRequested!();
                }
              },
        child: Center(
          child: isRefreshing ? _refreshing(context) : _clickToRefresh(context),
        ),
      ),
    );
  }

  Widget _clickToRefresh(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).translate("news_endoflist_title"),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
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
        Text(
          AppLocalizations.of(context).translate("news_endoflist_refreshing"),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
