import 'dart:async';

import '../../utils/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/scaffold_nav.dart';
import '../../utils/app_localizations.dart';
import '../../utils/get_device_type.dart';
import '../../viewmodel/account_session_instance.dart';
import '../../viewmodel/main_view_model.dart';
import '../../viewmodel/news_cache_instance.dart';
import '../../viewmodel/settings_instance.dart';
import 'tab_account/account_tab.dart';
import 'tab_dashboard/dashboard_tab.dart';
import 'tab_news/news_tab.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainScreenView> {
  int _selectedPage = 0;

  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _selectedPage);
  }

  @override
  Widget build(BuildContext context) {
    _initializeViewModels(context);
    if (_isViewModelInitialized) {
      return _mainView(context);
    } else {
      return _loadingView(context);
    }
  }

  Widget _loadingView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate("app_name"))),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: LinearProgressIndicator(),
            ),
            Text("We are setting up. Please wait a bit..."),
          ],
        ),
      ),
    );
  }

  Widget _mainView(BuildContext context) {
    var screenType = context.getDeviceType();

    return Scaffold(
      body: Row(
        children: [
          screenType.value > DeviceType.phone.value
              ? NavigationRail(
                  // extended: true,
                  groupAlignment: 0.0,
                  destinations: _getNavList(context).convertToListNavRailDestination(),
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
                DashboardTab(),
                NewsTab(),
                AccountTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: screenType.value <= DeviceType.phone.value
          ? NavigationBar(
              destinations: _getNavList(context).convertToListNavDestination(),
              selectedIndex: _selectedPage,
              onDestinationSelected: (index) {
                _controller.jumpToPage(index);
              },
            )
          : null,
    );
  }

  bool _isViewModelBeingInitialized = false;
  bool _isViewModelInitialized = false;

  Future<void> _initializeViewModels(BuildContext context) async {
    if (_isViewModelBeingInitialized) {
      return;
    }
    setState(() => _isViewModelBeingInitialized = true);

    // Initialize view models
    final mainViewModel = Provider.of<MainViewModel>(context, listen: false);
    // Initialize settings instance
    final settingsInstance = Provider.of<SettingsInstance>(context, listen: false);
    // Initialize news cache instance
    final newsCacheInstance = Provider.of<NewsCacheInstance>(context, listen: false);
    newsCacheInstance.timerInterval = settingsInstance.newsBackgroundDuration * 60 * 1000;
    // Initialize account session instance
    final accountSessionInstance = Provider.of<AccountSessionInstance>(context, listen: false);

    await Future.delayed(Duration(seconds: 10));

    // Update the state to indicate initialization is triggered (to avoid issue).
    setState(() => _isViewModelInitialized = true);
  }

  ScaffoldNavigationList _getNavList(BuildContext context) {
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
        label: AppLocalizations.of(context).translate("account_title"),
        iconData: Icons.account_circle_outlined,
      ),
    ]);
  }
}
