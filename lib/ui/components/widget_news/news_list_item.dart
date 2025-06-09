import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsListItem extends StatelessWidget {
  const NewsListItem({
    super.key,
    required this.newsItem,
    this.showDate = true,
    this.showShadow = true,
    this.shouldRadiusOnTop = false,
    this.shouldRadiusOnBottom = false,
    this.onClick,
  });

  final NewsGlobal newsItem;
  final bool showDate, showShadow;
  final bool shouldRadiusOnTop;
  final bool shouldRadiusOnBottom;
  final Function()? onClick;

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
      child: InkWell(
        onTap: () {
          if (onClick != null) {
            onClick!();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !showDate
                  ? const Center()
                  : Text(
                      DateFormat("dd/MM/yyyy", Localizations.localeOf(context).toString())
                          .format(DateTime.fromMillisecondsSinceEpoch(newsItem.date)),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
              SizedBox(height: showDate ? 7 : 0),
              Text(
                newsItem.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 7),
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
    );
  }
}
