import 'package:dutwrapper/model/news_global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/theme_tools.dart';

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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            // TODO: Change to dynamic color here!
            color: ThemeTool.isDarkMode(context)
                ? Theme.of(context).dialogBackgroundColor
                : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: !showShadow
                ? null
                : [
                    BoxShadow(
                      color: ThemeTool.isDarkMode(context)
                          ? Color.fromARGB(255, 56, 56, 56).withOpacity(0.5)
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !showDate
                    ? const Center()
                    : Text(
                        DateFormat("dd/MM/yyyy").format(
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
                  newsItem.contentString,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
