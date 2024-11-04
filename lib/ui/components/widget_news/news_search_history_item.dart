import 'package:dutwrapper/enums.dart';
import 'package:flutter/material.dart';

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
        subtitle: Text("Search by $searchMethod in $newsType"),
        trailing: Icon(Icons.north_west),
      ),
    );
  }
}
