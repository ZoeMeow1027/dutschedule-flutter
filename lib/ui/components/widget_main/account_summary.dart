import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/enum/process_state.dart';
import '../../../utils/app_localizations.dart';
import '../../../viewmodel/account_session_instance.dart';
import '../card_with_title.dart';

class MainDashboardWidgetAccountSummary extends StatelessWidget {
  const MainDashboardWidgetAccountSummary({
    super.key,
    this.onClick,
  });

  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    final accountSessionInstance = Provider.of<AccountSessionInstance>(context);
    return switch (accountSessionInstance.accountSession.state == ProcessState.successful) {
      true => _loggedIn(context, accountSessionInstance, onClick),
      false => _notLoggedIn(context, onClick),
    };
  }

  Widget _loggedIn(
    BuildContext context,
    AccountSessionInstance accountSessionInstance,
    Function()? onClick,
  ) {
    final dateTimeString =
        DateFormat("EE, dd/MM/yyyy", Localizations.localeOf(context).toString()).format(DateTime.now());
    final dateOfWeek = DateTime.now().weekday == 7 ? 1 : (DateTime.now().weekday + 1);
    // final dateOfWeek = 6;
    final isSuccessfulFetch = accountSessionInstance.subjectInformationList.state == ProcessState.successful;
    final subjectList = accountSessionInstance.subjectInformationList.data
        .where((p) => p.subjectStudy.subjectStudyList.any((p) => p.dayOfWeek == dateOfWeek))
        .map((p) => p.name)
        .toList();
    final subjectListString = subjectList.map((p) => '- $p').join('\n');

    return CardWithTitle(
      padding: EdgeInsets.symmetric(vertical: 3),
      title: AppLocalizations.of(context).translate("main_dashboard_widget_accountsummary_title"),
      onClick: onClick,
      child: Text(
        "${AppLocalizations.of(context).translateWithParameters(
          "main_dashboard_widget_accountsummary_newstoday",
          [dateTimeString],
        )}\n"
        "${switch (isSuccessfulFetch) {
          false => AppLocalizations.of(context).translate("main_dashboard_widget_accountsummary_newstoday_loadfailed"),
          true => switch (subjectList.isEmpty) {
              true =>
                AppLocalizations.of(context).translate("main_dashboard_widget_accountsummary_newstoday_emptylist"),
              false => subjectListString,
            }
        }}",
      ),
    );
  }

  Widget _notLoggedIn(
    BuildContext context,
    Function()? onClick,
  ) {
    return CardWithTitle(
      padding: EdgeInsets.symmetric(vertical: 3),
      title: AppLocalizations.of(context).translate("main_dashboard_widget_accountsummary_title"),
      onClick: onClick,
      child: Text(AppLocalizations.of(context).translate("main_dashboard_widget_accountsummary_notloggedin")),
    );
  }
}
