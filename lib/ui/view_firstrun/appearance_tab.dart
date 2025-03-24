import 'package:flutter/material.dart';

import 'base_tab.dart';

class GettingStartedAppearanceTab extends StatelessWidget {
  const GettingStartedAppearanceTab({
    super.key,
    this.prevPressed,
    this.nextPressed,
  });

  final Function()? prevPressed, nextPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Appearance",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "(You can always change this later in app settings)",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GettingStartedNavBarTab(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        backClicked: prevPressed,
        nextClicked: nextPressed,
      ),
    );
  }
}
