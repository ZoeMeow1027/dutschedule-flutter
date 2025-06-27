import 'package:dutwrapper/enums.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import '../../../utils/string_utils.dart';

class NewsSearchHistoryItem extends StatelessWidget {
  const NewsSearchHistoryItem({
    super.key,
    required this.query,
    required this.newsType,
    required this.searchMethod,
    this.shouldRadiusOnTop = false,
    this.shouldRadiusOnBottom = false,
    this.padding = EdgeInsets.zero,
    this.onClick,
  });

  final String query;
  final NewsType newsType;
  final NewsSearchMethod searchMethod;
  final EdgeInsets padding;
  final Function()? onClick;
  final bool shouldRadiusOnTop;
  final bool shouldRadiusOnBottom;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(shouldRadiusOnTop ? 20 : 5),
        topLeft: Radius.circular(shouldRadiusOnTop ? 20 : 5),
        bottomLeft: Radius.circular(shouldRadiusOnBottom ? 20 : 5),
        bottomRight: Radius.circular(shouldRadiusOnBottom ? 20 : 5),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50,
          minWidth: double.infinity,
        ),
        child: ListTile(
          onTap: onClick,
          leading: Icon(Icons.search),
          title: Text(query),
          subtitle: Text(StringUtils.formatString(
            AppLocalizations.of(context).translate("news_search_searchoption_history_data"),
            [
              switch (searchMethod) {
                NewsSearchMethod.byTitle =>
                  AppLocalizations.of(context).translate("news_search_searchoption_method_bytitle"),
                NewsSearchMethod.byContent =>
                  AppLocalizations.of(context).translate("news_search_searchoption_method_bycontent"),
              },
              switch (newsType) {
                NewsType.global => AppLocalizations.of(context).translate("news_search_searchoption_type_byglobal"),
                NewsType.subject => AppLocalizations.of(context).translate("news_search_searchoption_type_bysubject"),
                NewsType.studentAffairs =>
                  AppLocalizations.of(context).translate("news_search_searchoption_type_bystudentaffairs"),
                NewsType.examination =>
                  AppLocalizations.of(context).translate("news_search_searchoption_type_byexamination"),
                NewsType.tuitionFee =>
                  AppLocalizations.of(context).translate("news_search_searchoption_type_bytuitionfee"),
                NewsType.statutePolicy =>
                  AppLocalizations.of(context).translate("news_search_searchoption_type_bystatuteregulation"),
                _ => AppLocalizations.of(context).translate("data_unknown"),
              }
            ],
          )),
          trailing: Icon(Icons.north_west),
        ),
      ),
    );
  }
}
