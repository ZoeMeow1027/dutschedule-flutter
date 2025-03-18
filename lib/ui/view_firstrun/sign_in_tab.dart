import 'package:flutter/material.dart';

import 'app_banner.dart';

class GettingStartedSignInTab extends StatefulWidget {
  const GettingStartedSignInTab({
    super.key,
    this.prevPressed,
    this.finishPressed,
  });

  final Function()? prevPressed, finishPressed;

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
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: widget.prevPressed,
            label: Text("Previous"),
          ),
          TextButton.icon(
            onPressed: widget.finishPressed,
            label: Text("Skip this step"),
          ),
        ],
      ),
    );
  }
}
