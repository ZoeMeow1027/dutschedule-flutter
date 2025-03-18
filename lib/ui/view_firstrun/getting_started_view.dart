import 'agreement_tab.dart';
import 'appearance_tab.dart';
import 'sign_in_tab.dart';
import '../view_main/main_view.dart';

import 'package:flutter/material.dart';

import '../view_settings/languages_view.dart';

class GettingStartedWelcome extends StatefulWidget {
  const GettingStartedWelcome({super.key});

  @override
  State<StatefulWidget> createState() => _GettingStartedWelcome();
}

class _GettingStartedWelcome extends State<GettingStartedWelcome> {
  int _currentPage = 1;
  final PageController _pageViewController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async => await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LanguageSettingsView(),
              ),
            ),
            label: Text("Change language"),
            icon: Icon(Icons.language),
            iconAlignment: IconAlignment.end,
          ),
        ],
      ),
      body: PageView(
        controller: _pageViewController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            _currentPage = page + 1;
          });
        },
        children: [
          GettingStartedAgreementTab(
            nextPressed: () {
              _pageViewController.animateToPage(
                1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
              );
            },
          ),
          GettingStartedAppearanceTab(
            prevPressed: () {
              _pageViewController.animateToPage(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
              );
            },
            nextPressed: () {
              _pageViewController.animateToPage(
                2,
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
              );
            },
          ),
          GettingStartedSignInTab(
            prevPressed: () {
              _pageViewController.animateToPage(
                1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
              );
            },
            finishPressed: () async => await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreenView(),
              ),
              (route) => false,
            ),
          ),
        ],
      ),
    );
  }
}
