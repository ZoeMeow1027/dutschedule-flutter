import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:flutter/material.dart';

import '../../model/scaffold_nav.dart';
import '../../utils/get_device_type.dart';
import 'tab_account/account_tab.dart';
import 'tab_news/news_tab.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainScreenView> {
  int _selectedPage = 2;

  final ScaffoldNavigationList _navList = ScaffoldNavigationList(itemList: [
    ScaffoldNavigationItem(
      id: 0,
      label: "Dashboard",
      iconData: Icons.home,
    ),
    ScaffoldNavigationItem(
      id: 1,
      label: "News",
      iconData: Icons.newspaper,
    ),
    ScaffoldNavigationItem(
      id: 2,
      label: "Account",
      iconData: Icons.account_circle_outlined,
    ),
  ]);

  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _selectedPage);
  }

  @override
  Widget build(BuildContext context) {
    var screenType = context.getDeviceType();

    return Scaffold(
      body: Row(
        children: [
          screenType.value > DeviceType.phone.value
              ? NavigationRail(
            groupAlignment: 0.0,
                  destinations: _navList.convertToListNavRailDestination(),
                  selectedIndex: _selectedPage,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (index) {
                    _controller.jumpToPage(index);
                  },
                  minWidth: 80,
                )
              : const Center(),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              onPageChanged: (page) {
                setState(() {
                  _selectedPage = page;
                });
              },
              children: const <Widget>[
                Center(),
                NewsTab(),
                AccountTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: screenType.value <= DeviceType.phone.value
          ? NavigationBar(
              destinations: _navList.convertToListNavDestination(),
              selectedIndex: _selectedPage,
              onDestinationSelected: (index) {
                _controller.jumpToPage(index);
              },
            )
          : null,
    );
  }
}
