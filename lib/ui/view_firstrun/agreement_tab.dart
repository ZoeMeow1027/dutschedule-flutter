import 'package:flutter/material.dart';

import 'app_banner.dart';

class GettingStartedAgreementTab extends StatefulWidget {
  const GettingStartedAgreementTab({
    super.key,
    this.prevPressed,
    this.nextPressed,
  });

  final Function()? prevPressed, nextPressed;

  @override
  State<StatefulWidget> createState() => _GettingStartedAgreementTab();
}

class _GettingStartedAgreementTab extends State<GettingStartedAgreementTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GettingStartedAppBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Text("Thank you for using this application! However, you will need to accept some agreements below:"),
                Text("Terms of Service"),
                Text("Privacy Policy"),
                Text("DISCLAIMER"),
                Text("- This application (DutSchedule) is not affiliated with Da Nang University of Science and Technology."),
                Text(
                    "- DUT, Da Nang University of Science and Technology, web materials and web contents are trademarks and copyrights of Da Nang University of Science and Technology school."),
                Text("If you decline one of them, please stop using this application."),
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: widget.prevPressed,
            label: Text("Previous"),
          ),
          TextButton.icon(
            onPressed: widget.nextPressed,
            label: Text("Next"),
          ),
        ],
      ),
    );
  }
}
