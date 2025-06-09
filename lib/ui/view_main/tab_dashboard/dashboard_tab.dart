import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import '../../components/card_with_title.dart';
import '../../components/widget_main/date_time_card.dart';
import '../../view_miscellaneous/external_links_view.dart';
import '../../view_settings/settings_view.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("main_dashboard_title")),
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
            CardWithTitle(
              padding: EdgeInsets.symmetric(vertical: 3),
              title: "Your subjects today",
              child: Text(
                "Date & time: <place here>"
                "\n(based on your system settings)"
                "\n\nSchool year: <place here> - Week: <place here>"
                "\nCurrent lesson: <place here>",
              ),
              onClick: () {},
            ),
            CardWithTitle(
              padding: EdgeInsets.symmetric(vertical: 3),
              title: "School news",
              child: Text(
                "Today news count:"
                "\nGlobal: 7"
                "\nSubject: 15"
                "\nStudent affairs: 0"
                "\nExamination: 0"
                "\nTuition: 0",
              ),
            ),
            CardWithTitle(
              padding: EdgeInsets.symmetric(vertical: 3),
              title: AppLocalizations.of(context).translate("main_dashboard_widget_externallinks_title"),
              child: Text(AppLocalizations.of(context).translate("main_dashboard_widget_externallinks_description")),
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
