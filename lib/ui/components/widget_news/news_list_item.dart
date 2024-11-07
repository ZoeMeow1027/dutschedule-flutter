import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsListItem extends StatelessWidget {
  const NewsListItem({
    super.key,
    required this.newsItem,
    this.padding = const EdgeInsets.all(0),
    this.showDate = true,
    this.showShadow = true,
    this.onClick,
  });

  final NewsGlobal newsItem;
  final EdgeInsetsGeometry padding;
  final bool showDate, showShadow;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: () {
          if (onClick != null) {
            onClick!();
          }
        },
        child: Card.filled(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !showDate
                      ? const Center()
                      : Text(
                    DateFormat("dd/MM/yyyy", Localizations.localeOf(context).toString()).format(
                        DateTime.fromMillisecondsSinceEpoch(newsItem.date)),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      newsItem.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    newsItem.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
