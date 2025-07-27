import 'package:dutwrapper/news_object.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_localizations.dart';
import '../../../viewmodel/news_cache_instance_v2.dart';
import '../card_with_title.dart';

class TodaySchoolNewsCountCard extends StatelessWidget {
  const TodaySchoolNewsCountCard({
    super.key,
    this.onClickSwitchNewsTab,
  });

  final Function()? onClickSwitchNewsTab;

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      padding: EdgeInsets.symmetric(vertical: 3),
      title: AppLocalizations.of(context).translate("main_dashboard_widget_news_title"),
      onClick: onClickSwitchNewsTab,
      child: Text(_countTodayNews(context)),
    );
  }

  String _countTodayNews(BuildContext context) {
    final newsCacheInstance = Provider.of<NewsCacheInstanceV2>(context);
    var today = DateTime.now().toUtc().add(Duration(hours: 7));
    var todayAt0h = DateTime(today.year, today.month, today.day, 0, 0, 0).add(Duration(hours: -7));
    String dateTodayString = DateFormat('y/MM/d').format(today);

    List<NewsCore> getNewsTodayList(List<NewsCore> news) {
      return news.where((p) {
        return p.datePublished >= todayAt0h.millisecondsSinceEpoch;
      }).toList();
    }

    bool isNewsTodayListEmpty(List<NewsCore> news) {
      return getNewsTodayList(news).isEmpty;
    }

    int getNewsTodayCount(List<NewsCore> news) {
      return getNewsTodayList(news).length;
    }

    String getNewsTodayCountString(String title, List<NewsCore> news) {
      int count = getNewsTodayCount(news);
      if (count <= 0) {
        return "";
      } else if (count == 1) {
        return AppLocalizations.of(context).translateWithParameters(
          'main_dashboard_widget_news_newscount1',
          [title],
        );
      } else {
        return AppLocalizations.of(context).translateWithParameters(
          'main_dashboard_widget_news_newscountany',
          [title, count.toString()],
        );
      }
    }

    if (isNewsTodayListEmpty(newsCacheInstance.newsGlobal.data) &&
        isNewsTodayListEmpty(newsCacheInstance.newsSubject.data) &&
        isNewsTodayListEmpty(newsCacheInstance.newsStudentAffairs.data) &&
        isNewsTodayListEmpty(newsCacheInstance.newsExamination.data) &&
        isNewsTodayListEmpty(newsCacheInstance.newsTuitions.data) &&
        isNewsTodayListEmpty(newsCacheInstance.newsStatuteRegulation.data)) {
      return AppLocalizations.of(context).translateWithParameters(
        'main_dashboard_widget_news_nonews',
        [dateTodayString],
      );
    } else {
      return '${AppLocalizations.of(context).translateWithParameters(
        'main_dashboard_widget_news_hasnews',
        [dateTodayString],
      )}'
          "${getNewsTodayCountString(
        AppLocalizations.of(context).translate("main_dashboard_widget_news_newscount_global"),
        newsCacheInstance.newsGlobal.data,
      )}"
          "${getNewsTodayCountString(
        AppLocalizations.of(context).translate("main_dashboard_widget_news_newscount_subject"),
        newsCacheInstance.newsSubject.data,
      )}"
          "${getNewsTodayCountString(
        AppLocalizations.of(context).translate("main_dashboard_widget_news_newscount_studentaffairs"),
        newsCacheInstance.newsStudentAffairs.data,
      )}"
          "${getNewsTodayCountString(
        AppLocalizations.of(context).translate("main_dashboard_widget_news_newscount_examination"),
        newsCacheInstance.newsExamination.data,
      )}"
          "${getNewsTodayCountString(
        AppLocalizations.of(context).translate("main_dashboard_widget_news_newscount_tuition"),
        newsCacheInstance.newsTuitions.data,
      )}"
          "${getNewsTodayCountString(
        AppLocalizations.of(context).translate("main_dashboard_widget_news_newscount_statuteregulation"),
        newsCacheInstance.newsStatuteRegulation.data,
      )}";
    }
  }
}
