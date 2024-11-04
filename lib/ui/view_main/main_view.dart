import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../model/scaffold_nav.dart';
import '../../utils/get_device_type.dart';
import '../../viewmodel/account_session_instance.dart';
import '../../viewmodel/main_view_model.dart';
import '../../viewmodel/news_cache_instance.dart';
import 'tab_account/account_tab.dart';
import 'tab_news/news_tab.dart';

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
      label: "Accounts",
      iconData: Icons.account_circle_outlined,
    ),
  ]);

  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _selectedPage);

    // Defer initialization to after the first frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeViewModels();
    });
  }

  bool _isInitialized = false;

  Future<void> _initializeViewModels() async {
    if (_isInitialized) {
      return;
    }

    final mainViewModel = Provider.of<MainViewModel>(context, listen: false);
    final newsCacheInstance =
        Provider.of<NewsCacheInstance>(context, listen: false);
    final accountSessionInstance =
        Provider.of<AccountSessionInstance>(context, listen: false);

    // Initialize view models
    await mainViewModel.initialize();
    await newsCacheInstance.initialize();
    await accountSessionInstance.initialize();

    // Update the state to indicate initialization is complete
    setState(() => _isInitialized = true);
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
