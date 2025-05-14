import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import '../../components/card_with_title.dart';
import '../../components/widget_main/date_time_card.dart';
import '../../view_settings/settings_view.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          DateTimeCard(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          ),
          CardWithTitle(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
        ],
      ),
    );
  }
}
