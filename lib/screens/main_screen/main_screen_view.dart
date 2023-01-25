import 'package:flutter/material.dart';
import 'package:subject_notifier_flutter/model/scaffold_nav.dart';

import '../../utils/get_device_type.dart';
import 'views/account_tab.dart';
import 'views/news_tab.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainScreenView> {
  int _selectedPage = 1;

  final ScaffoldNavigationList _navList = ScaffoldNavigationList(itemList: [
    ScaffoldNavigationItem(
      id: 0,
      label: "Home",
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
    ScaffoldNavigationItem(
      id: 3,
      label: "Settings",
      iconData: Icons.settings,
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
    var screenType = getDeviceType(context);

    return Scaffold(
      body: Row(
        children: [
          screenType.value > DeviceType.phone.value
              ? NavigationRail(
                  destinations: _navList.convertToListNavRailDestination(),
                  selectedIndex: _selectedPage,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (index) {
                    _controller.jumpToPage(index);
                    // setState(() => {_selectedPage = index});
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
                Center(),
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
                // setState(() => {_selectedPage = index});
              },
            )
          : null,
    );
  }
}
