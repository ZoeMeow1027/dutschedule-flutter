import 'package:flutter/material.dart';

import 'app_banner.dart';
import 'base_tab.dart';

class GettingStartedAgreementTab extends StatefulWidget {
  const GettingStartedAgreementTab({
    super.key,
    this.nextPressed,
  });

  final Function()? nextPressed;

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
      bottomNavigationBar: GettingStartedNavBarTab(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        backEnabled: false,
        nextClicked: widget.nextPressed,
      ),
    );
  }
}
