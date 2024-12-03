import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:dutwrapper/account_session_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/process_state.dart';
import '../../../utils/app_localizations.dart';
import '../../../viewmodel/account_session_instance.dart';
import '../../../viewmodel/main_view_model.dart';
import '../../components/widget_main_tablet/clickable_card.dart';
import 'dashboard.dart';
import 'not_logged_in.dart';

class AccountTabletView extends StatelessWidget {
  const AccountTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate("account_title"))),
      body: accountSession.accountSession.state == ProcessState.successful
          ? _loggedInView(context)
          : _notLoggedInView(context),
    );
  }

  Widget _notLoggedInView(BuildContext context) {
    final mainViewModel = Provider.of<MainViewModel>(context);
    final accountSession = Provider.of<AccountSessionInstance>(context);

    return Center(
      child: Container(
        width: 450,
        alignment: Alignment.center,
        // TODO: Need to merge with [account_tab.dart]
        child: AccountNotLoggedInView(
          onAuthInfoChanged: (user, pass, remember) {
            mainViewModel.setAccountValue("username", user);
            mainViewModel.setAccountValue("password", pass);
            mainViewModel.setAccountValue("rememberLogin", remember);
          },
          loginRequested: () {
            accountSession.login(
              authInfo: AuthInfo(
                username: mainViewModel.accountParameter["username"] as String?,
                password: mainViewModel.accountParameter["password"] as String?,
              ),
              beforeRun: () {
                context.showCustomSnackBar(
                  content: Text(AppLocalizations.of(context).translate("account_login_loggingin")),
                  dismissOld: true,
                );
              },
              afterRun: () {
                switch (accountSession.accountSession.state) {
                  case ProcessState.successful:
                    context.showCustomSnackBar(
                      content: Text(AppLocalizations.of(context).translate("account_login_successful")),
                      dismissOld: true,
                    );
                    accountSession.fetchSubjectInformation();
                    accountSession.fetchSubjectFee();
                    accountSession.fetchStudentInformation();
                    accountSession.fetchTrainingResult();
                    break;
                  case ProcessState.failed:
                  case ProcessState.notRunYet:
                    context.showCustomSnackBar(
                      content: Text(AppLocalizations.of(context).translate("account_login_failed")),
                      dismissOld: true,
                    );
                    break;
                  default:
                    break;
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _loggedInView(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClickableCardInfo(
                  title: "Dashboard",
                  description: "1234",
                  onClick: () {},
                ),
                ClickableCardInfo(
                  title: "Subject Information",
                  description: "1234",
                  onClick: () {},
                ),
                ClickableCardInfo(
                  title: "Subject Fee",
                  description: "3 subjects remaining",
                  onClick: () {},
                ),
                ClickableCardInfo(
                  title: "Student Information",
                  description: "View all information about your account",
                  onClick: () {},
                ),
                ClickableCardInfo(
                  title: "Training Result",
                  description: "Your training result",
                  onClick: () {},
                ),
                ClickableCardInfo(
                  title: "Logout",
                  description: "Logout your account",
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
                              accountSession.logout(afterRun: () {
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
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, right: 10, bottom: 5),
            child: SizedBox(
              width: double.infinity,
              // TODO: Use another design because of not friendly UI for tablet
              child: AccountDashboardView(),
            ),
          ),
        ),
      ],
    );
  }
}
