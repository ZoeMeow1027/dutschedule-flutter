import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:flutter/material.dart';

import '../../../utils/get_device_type.dart';
import '../../news_detail/news_detail_view.dart';
import 'news_split_view.dart';
import 'news_summary_list_view.dart';

class NewsTab extends StatelessWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return context.getDeviceType().value > DeviceType.tablet.value
        ? NewsSplitView()
        : NewsSummaryListView(
            onClick: (news, isNewsSubject) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailView(
                    newsItem: news,
                    isNewsSubject: isNewsSubject,
                  ),
                ),
              );
            },
          );
  }
}
