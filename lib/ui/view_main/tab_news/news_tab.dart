import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/build_context_extension.dart';
import '../../../utils/get_device_type.dart';
import '../../../viewmodel/settings_instance.dart';
import '../../components/widget_news/news_detail_item.dart';
import '../../view_news/news_detail_view.dart';
import 'news_split_view.dart';
import 'news_summary_list_view.dart';

class NewsTab extends StatelessWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return context.getDeviceType().value > DeviceType.tablet.value
        ? NewsSplitView()
        : NewsSummaryListView(
            onClick: (news, isNewsSubject) async {
              if (settingsInstance.openNewsInModalBottomSheet) {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) => FractionallySizedBox(
                    heightFactor: 0.75,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 30),
                      child: NewsDetailItem(
                        newsItem: news,
                        isNewsSubject: isNewsSubject,
                      ),
                    ),
                  ),
                );
              } else {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailView(
                      newsItem: news,
                      isNewsSubject: isNewsSubject,
                    ),
                  ),
                );
              }
            },
          );
  }
}
