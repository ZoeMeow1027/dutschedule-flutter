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
    this.padding = EdgeInsets.zero,
    this.onClick,
  });

  final String query;
  final NewsType newsType;
  final NewsSearchMethod searchMethod;
  final EdgeInsets padding;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      child: ListTile(
        onTap: onClick,
        leading: Icon(Icons.search),
        title: Text(query),
        subtitle: Text(StringUtils.formatString(
          AppLocalizations.of(context).translate("news_search_searchoption_history_data"),
          [
            searchMethod == NewsSearchMethod.byTitle
                ? AppLocalizations.of(context).translate("news_search_searchoption_method_bytitle")
                : AppLocalizations.of(context).translate("news_search_searchoption_method_bycontent"),
            newsType == NewsType.global
                ? AppLocalizations.of(context).translate("news_search_searchoption_type_byglobal")
                : AppLocalizations.of(context).translate("news_search_searchoption_type_bysubject"),
          ],
        )),
        trailing: Icon(Icons.north_west),
      ),
    );
  }
}
