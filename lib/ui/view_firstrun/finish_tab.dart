import 'package:flutter/material.dart';

import 'app_banner.dart';
import 'base_tab.dart';

class GettingStartedFinishTab extends StatelessWidget {
  const GettingStartedFinishTab({
    super.key,
    this.finishPressed,
  });

  final Function()? finishPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GettingStartedAppBanner(
              showText: false
            ),
            Text(
              "Welcome to DutSchedule",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                "Thanks again for using this application!",
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GettingStartedNavBarTab(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        backEnabled: false,
        nextClicked: finishPressed,
        isNextFinished: true,
      ),
    );
  }

}