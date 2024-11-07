import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_localizations.dart';
import '../../../viewmodel/main_view_model.dart';
import '../../components/widget_news/news_detail_item.dart';
import 'news_summary_list_view.dart';

class NewsSplitView extends StatelessWidget {
  const NewsSplitView({super.key});

  @override
  Widget build(BuildContext context) {
    final mainViewModel = Provider.of<MainViewModel>(context);

    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 450,
            child: NewsSummaryListView(
              onClick: (news, isNewsSubject) {
                mainViewModel.setNewsSelected(
                  news: news,
                  isNewsSubject: isNewsSubject,
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, right: 10, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogTheme.backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: mainViewModel.newsSelected == null
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context).translate("news_splitview_noselected"),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : NewsDetailItem(
                          newsItem: mainViewModel.newsSelected!,
                          isNewsSubject: mainViewModel.newsSelectedIsSubject,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
