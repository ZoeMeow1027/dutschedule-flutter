import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import '../../../utils/string_utils.dart';

class TrainingSummary extends StatelessWidget {
  const TrainingSummary({
    super.key,
    required this.score,
    this.schoolYearUpdated,
    this.onClick,
  });

  final double score;
  final String? schoolYearUpdated;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  AppLocalizations.of(context).translate("account_trainingstatus_trainbox_title"),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "$score",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 44,
                        )),
                    TextSpan(
                        text: "/4",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                        )),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                StringUtils.formatString(
                  AppLocalizations.of(context).translate("account_trainingstatus_trainbox_schyear"),
                  [schoolYearUpdated.toString()],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 3),
                child: FilledButton(
                  onPressed: () {
                    onClick?.call();
                  },
                  child: Text(AppLocalizations.of(context).translate("account_trainingstatus_trainbox_schbutton")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
