import 'package:flutter/material.dart';

import 'app_banner.dart';

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
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: prevPressed,
            label: Text("Previous"),
          ),
          TextButton.icon(
            onPressed: nextPressed,
            label: Text("Next"),
          ),
        ],
      ),
    );
  }
}
