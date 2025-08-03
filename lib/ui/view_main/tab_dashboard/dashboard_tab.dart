import 'package:dutschedule/ui/components/widget_main/external_links_card.dart';
import 'package:dutschedule/ui/components/widget_main/today_school_news_count_card.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../components/widget_main/account_summary.dart';
import '../../components/widget_main/date_time_card.dart';
import '../../view_miscellaneous/external_links_view.dart';
import '../../view_settings/settings_view.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({
    super.key,
    this.onClickSwitchNewsTab,
    this.onClickSwitchAccountTab,
  });

  final Function()? onClickSwitchNewsTab;
  final Function()? onClickSwitchAccountTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate('main_dashboard_title')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsView()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            DateTimeCard(
              padding: EdgeInsets.symmetric(vertical: 3),
            ),
            MainDashboardWidgetAccountSummary(
              onClick: onClickSwitchAccountTab,
            ),
            TodaySchoolNewsCountCard(
              onClickSwitchNewsTab: onClickSwitchNewsTab,
            ),
            ExternalLinksCard(
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExternalLinkMiscellaneousView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
