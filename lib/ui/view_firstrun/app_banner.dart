import 'package:flutter/material.dart';

import '../../utils/app_localizations.dart';

class GettingStartedAppBanner extends StatelessWidget {
  const GettingStartedAppBanner({
    super.key,
    this.showText = true,
  });

  final bool showText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: ClipOval(
              child: Image(
                image: AssetImage('assets/app_icon_512.png'),
                width: 128,
                height: 128,
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (showText)
            Text(
              AppLocalizations.of(context).translate("app_name"),
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          if (showText)
            Text(
              "An unofficial Android app to provide better UI from sv.dut.udn.vn. Written with Flutter.",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
