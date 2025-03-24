import 'package:flutter/material.dart';

import 'base_tab.dart';

class GettingStartedSignInTab extends StatefulWidget {
  const GettingStartedSignInTab({
    super.key,
    this.prevPressed,
    this.nextPressed,
  });

  final Function()? prevPressed, nextPressed;

  @override
  State<StatefulWidget> createState() => _GettingStartedSignInTab();
}

class _GettingStartedSignInTab extends State<GettingStartedSignInTab> {
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
              "Sign in",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Use your account in sv.dut.udn.vn to login.",
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GettingStartedNavBarTab(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        backClicked: widget.prevPressed,
        nextClicked: widget.nextPressed,
        isNextSkip: true,
      ),
    );
  }
}
