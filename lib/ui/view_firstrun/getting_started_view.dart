import 'package:dutschedule/ui/view_firstrun/finish_tab.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/settings_instance.dart';
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
    final settingsInstance = Provider.of<SettingsInstance>(context);

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
                duration: const Duration(milliseconds: 300),
                curve: Curves.linearToEaseOut,
              );
            },
          ),
          GettingStartedAppearanceTab(
            prevPressed: () {
              _pageViewController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linearToEaseOut,
              );
            },
            nextPressed: () {
              _pageViewController.animateToPage(
                2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linearToEaseOut,
              );
            },
          ),
          GettingStartedSignInTab(prevPressed: () {
            _pageViewController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linearToEaseOut,
            );
          }, nextPressed: () {
            _pageViewController.animateToPage(
              3,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linearToEaseOut,
            );
          }),
          GettingStartedFinishTab(
            finishPressed: () async {
              settingsInstance.firstRunDone = true;
              await Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => MainScreenView(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    final fadeInOut = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    );

                    return FadeTransition(
                      opacity: fadeInOut,
                      child: child,
                    );
                  },
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
