import 'package:flutter/material.dart';

import '../../utils/app_localizations.dart';

class GettingStartedNavBarTab extends StatelessWidget {
  const GettingStartedNavBarTab({
    super.key,
    this.backEnabled = true,
    this.nextEnabled = true,
    this.backClicked,
    this.nextClicked,
    this.isNextFinished = false,
    this.isNextSkip = false,
    this.padding = EdgeInsets.zero,
  });

  final bool backEnabled, nextEnabled;
  final Function()? backClicked, nextClicked;
  final bool isNextFinished, isNextSkip;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (backEnabled)
            FilledButton.tonalIcon(
              onPressed: backClicked,
              label: Text(AppLocalizations.of(context).translate("action_previous")),
            ),
          if (nextEnabled)
            FilledButton.tonalIcon(
              onPressed: nextClicked,
              label: Text(
                isNextFinished
                    ? AppLocalizations.of(context).translate("action_done")
                    : isNextSkip
                        ? AppLocalizations.of(context).translate("action_skip")
                        : AppLocalizations.of(context).translate("action_next"),
              ),
            ),
        ],
      ),
    );
  }
}
