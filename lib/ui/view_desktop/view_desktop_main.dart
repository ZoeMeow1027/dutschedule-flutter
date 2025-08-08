import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/settings_instance.dart';
import '../view_main/tab_account/account_tab.dart';
import '../view_main/tab_dashboard/dashboard_tab.dart';
import '../view_main/tab_news/news_tab.dart';
import '../view_main/tab_notifications/notifications_tab.dart';
import '../view_settings/settings_view.dart';

class ViewDesktopMain extends StatefulWidget {
  // TODO: Not completed yet!!!!
  const ViewDesktopMain({super.key});

  @override
  State<StatefulWidget> createState() => _ViewDesktopMainState();
}

class _ViewDesktopMainState extends State<ViewDesktopMain> {
  int _selectedPage = 0;

  // late PageController _controller;
  late List<Widget> _pages;

  @override
  void initState() {
    // TODO: implement initState
    _pages = <Widget>[
      DashboardTab(
        onClickSwitchNewsTab: () {
          setState(() => _selectedPage = 1);
        },
        onClickSwitchAccountTab: () {
          setState(() => _selectedPage = 3);
        },
        showSettingsButton: false,
      ),
      NewsTab(),
      NotificationsTab(),
      AccountTab(),
    ];
    super.initState();
    // _controller = PageController(initialPage: _selectedPage);
  }

  @override
  Widget build(BuildContext context) {
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text('DutSchedule'),
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
      body: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 450,
              child: _pages.elementAt(0),
            ),
            SizedBox(
              width: 450,
              child: _pages.elementAt(1),
            ),
          ],
        ),
      ),
    );
  }
}
