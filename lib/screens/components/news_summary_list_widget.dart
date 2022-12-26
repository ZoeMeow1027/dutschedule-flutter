import 'package:dutwrapper/model/news_obj.dart';
import 'package:flutter/material.dart';
import 'package:subject_notifier_flutter/screens/components/news_summary_item_widget.dart';

class NewsSummaryListWidget extends StatelessWidget {
  const NewsSummaryListWidget({
    super.key,
    required this.newsList,
  });

  final List<NewsGlobal> newsList;

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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
