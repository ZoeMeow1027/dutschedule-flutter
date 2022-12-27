import 'package:dutwrapper/model/news_obj.dart';
import 'package:flutter/material.dart';

import 'news_summary_item_widget.dart';

class NewsSummaryListWidget extends StatelessWidget {
  const NewsSummaryListWidget({
    super.key,
    required this.newsList,
    this.onClick,
  });

  final List<NewsGlobal> newsList;
  final Function(NewsGlobal)? onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              newsList.length,
              (index) => NewsSummaryItemWidget(
                newsItem: newsList[index],
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                onClick: () {
                  if (onClick != null) {
                    onClick!(newsList[index]);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
