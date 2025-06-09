import 'package:dutschedule/ui/components/menu_list_group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/process_state.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/build_context_extension.dart';
import '../../../viewmodel/account_session_instance.dart';
import '../../components/message_card.dart';
import '../../components/widget_account/dashboard_basic_info_view.dart';
import '../../view_accounts/student_information_view.dart';
import '../../view_accounts/subject_fee_view.dart';
import '../../view_accounts/subject_information_view.dart';
import '../../view_accounts/training_result_view.dart';

class AccountDashboardView extends StatelessWidget {
  const AccountDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountSessionInstance = Provider.of<AccountSessionInstance>(context);
    return Padding(
      padding: const EdgeInsets.only(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Processing status
            (accountSessionInstance.accountSession.state == ProcessState.running)
                ? Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: MessageCard.processing(
                      // padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppLocalizations.of(context).translate("account_status_processing"),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                : Container(),
            (accountSessionInstance.accountSession.state == ProcessState.notRunYet ||
                    accountSessionInstance.accountSession.state == ProcessState.failed)
                ? Padding(
                    padding: EdgeInsetsGeometry.only(bottom: 10),
                    child: MessageCard.warning(
                      // padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppLocalizations.of(context).translate("account_status_failed"),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: context.isOSDarkMode() ? Colors.black : null),
                      ),
                      onClick: () {
                        if (accountSessionInstance.authInfo != null) {
                          accountSessionInstance.reLogin(
                            forceRequest: true,
                            afterRun: (successful) async {
                              if (successful) {
                                await accountSessionInstance.fetchStudentInformation(forceRequest: true);
                              } else {
                                await accountSessionInstance.login(
                                  authInfo: accountSessionInstance.authInfo,
                                  afterRun: (successful) async {
                                    if (successful) {
                                      await accountSessionInstance.fetchStudentInformation(forceRequest: true);
                                    } else {
                                      // Notify error for user about unsuccessful login.
                                      context.showCustomSnackBar(
                                        content: Text(AppLocalizations.of(context)
                                            .translate("main_preload_preloadfailed_reloginaccount")),
                                        dismissOld: true,
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  )
                : Container(),
            // Account Information
            DashboardBasicInfoView(
              padding: const EdgeInsets.only(bottom: 15),
              name: accountSessionInstance.studentInformation.data?.name,
              studentId: accountSessionInstance.studentInformation.data?.studentId,
              schoolClass: accountSessionInstance.studentInformation.data?.schoolClass,
              specialization: accountSessionInstance.studentInformation.data?.specialization,
              isRunning: accountSessionInstance.studentInformation.state == ProcessState.running,
              onClick: () {
                if (accountSessionInstance.accountSession.state == ProcessState.running) {
                  return;
                }
                // accountSessionInstance.fetchStudentInformation();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentInformationView()),
                );
              },
            ),
            MenuListGroup(
              itemMinHeight: 60,
              itemList: [
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("account_dashboard_button_subjectinfo"),
                  spaceForEmptyLeading: true,
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubjectInformationView()),
                    );
                  },
                ),
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("account_dashboard_button_subjectfee"),
                  spaceForEmptyLeading: true,
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubjectFeeView()),
                    );
                  },
                ),
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("account_dashboard_button_accounttrainstats"),
                  spaceForEmptyLeading: true,
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrainingResultView()),
                    );
                  },
                ),
                MenuListGroupItem(
                  title: AppLocalizations.of(context).translate("account_dashboard_button_logout"),
                  leading: Icon(Icons.logout),
                  spaceForEmptyLeading: true,
                  onClick: () async {
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
                                context.showCustomSnackBar(
                                  content: Text(AppLocalizations.of(context).translate("account_logout_loggedout")),
                                  dismissOld: true,
                                );
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
          ],
        ),
      ),
    );
  }
}
