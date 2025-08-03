import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../model/enum/device_type.dart';
import '../../model/scaffold_nav.dart';
import '../../utils/build_context_extension.dart';
import '../../viewmodel/notification_instance.dart';
import 'tab_account/account_tab.dart';
import 'tab_dashboard/dashboard_tab.dart';
import 'tab_news/news_tab.dart';
import 'tab_notifications/notifications_tab.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainScreenView> {
  int _selectedPage = 0;

  // late PageController _controller;
  late List<Widget> _pages;

  @override
  void initState() {
    _pages = <Widget>[
      DashboardTab(
        onClickSwitchNewsTab: () {
          setState(() => _selectedPage = 1);
        },
        onClickSwitchAccountTab: () {
          setState(() => _selectedPage = 3);
        },
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
    var screenType = context.getDeviceType();

    return Scaffold(
      body: Row(
        children: [
          screenType.value > DeviceType.phone.value
              ? NavigationRail(
                  leading: Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: ClipOval(
                      child: Image(
                        image: AssetImage('assets/icons/app_icon_512.png'),
                        width: 96,
                        height: 96,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  useIndicator: true,
                  extended: true,
                  groupAlignment: -1.0,
                  destinations: _getNavList(context).toNavRailDestinationList(),
                  selectedIndex: _selectedPage,
                  labelType: NavigationRailLabelType.none,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedPage = index;
                    });
                  },
                  minWidth: 80,
                )
              : const Center(),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 150),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
              child: _pages[_selectedPage],
            ),
          ),
        ],
      ),
      bottomNavigationBar: screenType.value <= DeviceType.phone.value
          ? NavigationBar(
              destinations: _getNavList(context).toListNavDestinationList(),
              selectedIndex: _selectedPage,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedPage = index;
                });
              },
            )
          : null,
    );
  }

  // Widget _buildv1() {
  //   var screenType = context.getDeviceType();

  //   return Scaffold(
  //     body: Row(
  //       children: [
  //         screenType.value > DeviceType.phone.value
  //             ? NavigationRail(
  //                 // extended: true,
  //                 groupAlignment: 0.0,
  //                 destinations: _getNavList(context).convertToListNavRailDestination(),
  //                 selectedIndex: _selectedPage,
  //                 labelType: NavigationRailLabelType.all,
  //                 onDestinationSelected: (index) {
  //                   _controller.animateToPage(
  //                     index,
  //                     duration: const Duration(milliseconds: 300),
  //                     curve: Curves.fastLinearToSlowEaseIn,
  //                   );
  //                 },
  //                 minWidth: 80,
  //               )
  //             : const Center(),
  //         Expanded(
  //           child: PageView(
  //             physics: const NeverScrollableScrollPhysics(),
  //             controller: _controller,
  //             onPageChanged: (page) {
  //               setState(() {
  //                 _selectedPage = page;
  //               });
  //             },
  //             children: const <Widget>[
  //               DashboardTab(),
  //               NewsTab(),
  //               NotificationsTab(),
  //               AccountTab(),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //     bottomNavigationBar: screenType.value <= DeviceType.phone.value
  //         ? NavigationBar(
  //             destinations: _getNavList(context).convertToListNavDestination(),
  //             selectedIndex: _selectedPage,
  //             onDestinationSelected: (index) {
  //               _controller.animateToPage(
  //                 index,
  //                 duration: const Duration(milliseconds: 300),
  //                 curve: Curves.fastLinearToSlowEaseIn,
  //               );
  //             },
  //           )
  //         : null,
  //   );
  // }

  ScaffoldNavigationList _getNavList(BuildContext context) {
    final notificationInstance = Provider.of<NotificationInstance>(context);
    return ScaffoldNavigationList(itemList: [
      ScaffoldNavigationItem(
        id: 0,
        label: AppLocalizations.of(context).translate("main_dashboard_title"),
        iconData: Icons.home,
      ),
      ScaffoldNavigationItem(
        id: 1,
        label: AppLocalizations.of(context).translate("news_title"),
        iconData: Icons.newspaper,
      ),
      ScaffoldNavigationItem(
        id: 2,
        label: AppLocalizations.of(context).translate("notification_panel_title"),
        badgeText: notificationInstance.notificationHistoryList.isNotEmpty
            ? notificationInstance.notificationHistoryList.length.toString()
            : null,
        iconData: Icons.notifications,
      ),
      ScaffoldNavigationItem(
        id: 3,
        label: AppLocalizations.of(context).translate("account_title"),
        iconData: Icons.account_circle_outlined,
      ),
    ]);
  }
}
