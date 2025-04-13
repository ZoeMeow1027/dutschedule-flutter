import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:dutwrapper/account_session_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/process_state.dart';
import '../../../utils/app_localizations.dart';
import '../../../viewmodel/account_session_instance.dart';
import '../../../viewmodel/main_view_model.dart';
import '../../view_settings/settings_view.dart';
import 'dashboard.dart';
import 'not_logged_in.dart';

class AccountMobileView extends StatelessWidget {
  const AccountMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final mainViewModel = Provider.of<MainViewModel>(context);
    final accountSession = Provider.of<AccountSessionInstance>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("account_title")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsView()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _checkIfDashboardShouldShown(context)
          ? AccountDashboardView()
          : AccountNotLoggedInView(
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
                  afterRun: (successful) {
                    switch (accountSession.accountSession.state) {
                      case ProcessState.successful:
                        context.showCustomSnackBar(
                          content: Text(AppLocalizations.of(context).translate("account_login_successful")),
                          dismissOld: true,
                        );
                        accountSession.fetchStudentInformation();
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
    );
  }

  bool _checkIfDashboardShouldShown(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);
    if (accountSession.accountSession.state == ProcessState.successful) {
      return true;
    }

    if (accountSession.accountSession.data != null) {
      if (accountSession.accountSession.data?.sessionId != null) {
        return true;
      }
      return false;
    }

    return false;
  }
}
