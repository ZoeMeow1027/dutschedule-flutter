import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import '../../components/widget_news/news_detail_item.dart';
import 'news_summary_list_view.dart';

class NewsSplitView extends StatefulWidget {
  const NewsSplitView({super.key});

  @override
  State<StatefulWidget> createState() => _NewsSplitView();
}

class _NewsSplitView extends State<NewsSplitView> {
  NewsGlobal? _newsSelected;
  bool _newsSelectedIsSubject = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 450,
          child: NewsSummaryListView(
            onClick: (news, isNewsSubject) {
              setState(() {
                _newsSelected = news;
                _newsSelectedIsSubject = isNewsSubject;
              });
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
                child: _newsSelected == null
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).translate("news_splitview_noselected"),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : NewsDetailItem(
                        newsItem: _newsSelected!,
                        isNewsSubject: _newsSelectedIsSubject,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
