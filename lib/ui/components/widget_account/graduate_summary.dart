import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/string_utils.dart';
import '../info_card.dart';

class GraduateSummary extends StatelessWidget {
  const GraduateSummary({
    super.key,
    this.graduateStatus,
    this.onCopy,
  });

  final GraduateStatus? graduateStatus;
  final Function(String)? onCopy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        // borderRadius: BorderRadius.only(
        //   topRight: Radius.circular(20),
        //   topLeft: Radius.circular(20),
        //   bottomLeft: Radius.circular(20),
        //   bottomRight: Radius.circular(20),
        // ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Text(
                  AppLocalizations.of(context).translate("account_trainingstatus_graduatebox_title"),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                graduateStatus?.hasQualifiedGraduate == true
                    ? AppLocalizations.of(context).translate("account_trainingstatus_graduatebox_elegibletograduate")
                    : (graduateStatus?.hasSigGDQP == true &&
                            graduateStatus?.hasSigGDTC == true &&
                            graduateStatus?.hasSigEnglish == true &&
                            graduateStatus?.hasSigIT == true)
                        ? AppLocalizations.of(context)
                            .translate("account_trainingstatus_graduatebox_nottickedelegibletograduate")
                        : AppLocalizations.of(context)
                            .translate("account_trainingstatus_graduatebox_notelegibletograduate"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card.filled(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("account_trainingstatus_graduatebox_certandgraduateresult"),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(value: graduateStatus?.hasSigGDTC == true, onChanged: null),
                            Text(AppLocalizations.of(context)
                                .translate("account_trainingstatus_graduatebox_certandgraduateresult_havepe")),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(value: graduateStatus?.hasSigGDQP == true, onChanged: null),
                            Text(AppLocalizations.of(context)
                                .translate("account_trainingstatus_graduatebox_certandgraduateresult_havende")),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(value: graduateStatus?.hasSigEnglish == true, onChanged: null),
                            Text(AppLocalizations.of(context)
                                .translate("account_trainingstatus_graduatebox_certandgraduateresult_haveenglish")),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(value: graduateStatus?.hasSigIT == true, onChanged: null),
                            Text(AppLocalizations.of(context)
                                .translate("account_trainingstatus_graduatebox_certandgraduateresult_haveit")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InfoCard(
                title: AppLocalizations.of(context)
                    .translate("account_trainingstatus_graduatebox_certandgraduateresult_rewards"),
                description: graduateStatus?.rewardsInfo,
                showNoDataText: true,
                trailingWidget: IconButton(
                  onPressed: () {
                    onCopy?.call(StringUtils.formatString(
                      "{0}: {1}",
                      [
                        AppLocalizations.of(context)
                            .translate("account_trainingstatus_graduatebox_certandgraduateresult_rewards"),
                        graduateStatus?.rewardsInfo ?? AppLocalizations.of(context).translate("data_unknown"),
                      ],
                    ));
                  },
                  icon: Icon(Icons.copy),
                ),
              ),
              InfoCard(
                title: AppLocalizations.of(context)
                    .translate("account_trainingstatus_graduatebox_certandgraduateresult_discipline"),
                description: graduateStatus?.disciplineInfo,
                showNoDataText: true,
                trailingWidget: IconButton(
                  onPressed: () {
                    onCopy?.call(StringUtils.formatString(
                      "{0}: {1}",
                      [
                        AppLocalizations.of(context)
                            .translate("account_trainingstatus_graduatebox_certandgraduateresult_discipline"),
                        graduateStatus?.disciplineInfo ?? AppLocalizations.of(context).translate("data_unknown"),
                      ],
                    ));
                  },
                  icon: Icon(Icons.copy),
                ),
              ),
              InfoCard(
                title: AppLocalizations.of(context)
                    .translate("account_trainingstatus_graduatebox_certandgraduateresult_graduationthesisapproval"),
                description: graduateStatus?.eligibleGraduationThesisStatus,
                showNoDataText: true,
                trailingWidget: IconButton(
                  onPressed: () {
                    onCopy?.call(StringUtils.formatString(
                      "{0}: {1}",
                      [
                        AppLocalizations.of(context).translate(
                            "account_trainingstatus_graduatebox_certandgraduateresult_graduationthesisapproval"),
                        graduateStatus?.eligibleGraduationThesisStatus ??
                            AppLocalizations.of(context).translate("data_unknown"),
                      ],
                    ));
                  },
                  icon: Icon(Icons.copy),
                ),
              ),
              InfoCard(
                title: AppLocalizations.of(context)
                    .translate("account_trainingstatus_graduatebox_certandgraduateresult_graduationprocessapproval"),
                description: graduateStatus?.eligibleGraduationStatus,
                showNoDataText: true,
                trailingWidget: IconButton(
                  onPressed: () {
                    onCopy?.call(StringUtils.formatString(
                      "{0}: {1}",
                      [
                        AppLocalizations.of(context).translate(
                            "account_trainingstatus_graduatebox_certandgraduateresult_graduationprocessapproval"),
                        graduateStatus?.eligibleGraduationStatus ??
                            AppLocalizations.of(context).translate("data_unknown"),
                      ],
                    ));
                  },
                  icon: Icon(Icons.copy),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
