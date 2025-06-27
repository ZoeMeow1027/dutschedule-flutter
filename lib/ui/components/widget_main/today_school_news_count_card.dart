import 'package:dutwrapper/news_object.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_localizations.dart';
import '../../../viewmodel/news_cache_instance.dart';
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
    final newsCacheInstance = Provider.of<NewsCacheInstance>(context);
    String dateToday = DateFormat('y/MM/d').format(DateTime.now());

    if (newsCacheInstance.newsGlobal.data.isEmpty &&
        newsCacheInstance.newsSubject.data.isEmpty &&
        newsCacheInstance.newsStudentAffairs.data.isEmpty &&
        newsCacheInstance.newsExamination.data.isEmpty &&
        newsCacheInstance.newsTuitions.data.isEmpty) {
      return "No news on $dateToday (Click here to open \"news\" tab)";
    } else {
      int getNewsSubjectTodayCount(List<NewsGlobal> news) {
        var today = DateTime.now().toUtc().add(Duration(hours: 7));
        var todayAt0h = DateTime(today.year, today.month, today.day, 0, 0, 0).add(Duration(hours: -7));
        return news
            .where((p) {
              return p.date >= todayAt0h.millisecondsSinceEpoch;
            })
            .toList()
            .length;
      }

      String stringNewsCount(String title, List<NewsGlobal> news) {
        int count = getNewsSubjectTodayCount(news);
        if (count <= 0) {
          return "";
        } else if (count == 1) {
          return "\n$title: 1 item";
        } else {
          return "\n$title: $count items";
        }
      }

      return "News count on $dateToday (Click here to open \"news\" tab)\n"
          "${stringNewsCount("Global news", newsCacheInstance.newsGlobal.data)}"
          "${stringNewsCount("Subject news", newsCacheInstance.newsSubject.data)}"
          "${stringNewsCount("Student affairs news", newsCacheInstance.newsStudentAffairs.data)}"
          "${stringNewsCount("Examination news", newsCacheInstance.newsExamination.data)}"
          "${stringNewsCount("Tuition fee news", newsCacheInstance.newsTuitions.data)}";
    }
  }
}
