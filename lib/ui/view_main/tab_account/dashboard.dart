import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/process_state.dart';
import '../../../utils/app_localizations.dart';
import '../../../viewmodel/account_session_instance.dart';
import '../../components/message_card.dart';
import '../../components/widget_account/dashboard_basic_info_view.dart';
import '../../view_accounts/student_information_view.dart';
import '../../view_accounts/subject_fee_view.dart';
import '../../view_accounts/subject_information_view.dart';

class AccountDashboardView extends StatelessWidget {
  const AccountDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountSessionInstance = Provider.of<AccountSessionInstance>(context);
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Processing status
          (accountSessionInstance.accountSession.state == ProcessState.running)
              ? MessageCard.processing(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    AppLocalizations.of(context).translate("account_status_processing"),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : Container(),
          (accountSessionInstance.accountSession.state == ProcessState.failed)
              ? MessageCard.warning(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    AppLocalizations.of(context).translate("account_status_failed"),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: context.isDarkMode() ? Colors.black : null),
                  ),
                  onClick: () {
                    accountSessionInstance.reLogin();
                  },
                )
              : Container(),
          // Account Information
          DashboardBasicInfoView(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            name: accountSessionInstance.studentInformation.data?.name,
            studentId: accountSessionInstance.studentInformation.data?.studentId,
            schoolClass: accountSessionInstance.studentInformation.data?.schoolClass,
            specialization: accountSessionInstance.studentInformation.data?.specialization,
            isRunning: accountSessionInstance.studentInformation.state == ProcessState.running,
            onClick: () {
              if (accountSessionInstance.accountSession.state == ProcessState.running) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentInformationView()),
              );
            },
          ),
          // Button action
          _customButton(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
            child: Text(AppLocalizations.of(context).translate("account_dashboard_button_subjectinfo")),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubjectInformationView()),
              );
            },
          ),
          _customButton(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
            child: Text(AppLocalizations.of(context).translate("account_dashboard_button_subjectfee")),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubjectFeeView()),
              );
            },
          ),
          _customButton(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
            child: Text(AppLocalizations.of(context).translate("account_dashboard_button_accounttrainstats")),
            onPressed: () {},
          ),
          _customButton(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
            child: Text(AppLocalizations.of(context).translate("account_dashboard_button_logout")),
            onPressed: () async {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(AppLocalizations.of(context).translate("account_logout_title")),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context).translate("account_logout_description")),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(AppLocalizations.of(context).translate("account_logout_action_logout")),
                      onPressed: () {
                        Navigator.pop(context);
                        accountSessionInstance.logout(afterRun: () {
                          context.clearSnackBars();
                          context.showSnackBar(SnackBar(
                            content: Text(AppLocalizations.of(context).translate("account_logout_loggedout")),
                          ));
                        });
                      },
                    ),
                    TextButton(
                      child: Text(AppLocalizations.of(context).translate("action_cancel")),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _customButton({
    required Widget child,
    EdgeInsets padding = EdgeInsets.zero,
    Function()? onPressed,
  }) {
    return Padding(
      padding: padding,
      child: FilledButton.tonal(
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
