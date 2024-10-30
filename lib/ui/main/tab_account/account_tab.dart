import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:dutschedule/viewmodel/account_session_instance.dart';
import 'package:dutwrapper/account_session_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/process_state.dart';
import '../../../viewmodel/main_viewmodel.dart';
import 'dashboard.dart';
import 'not_logged_in.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final mainViewModel = Provider.of<MainViewModel>(context);
    final accountSession = Provider.of<AccountSessionInstance>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: accountSession.accountSession.state == ProcessState.successful
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
                      username:
                          mainViewModel.accountParameter["username"] as String?,
                      password:
                          mainViewModel.accountParameter["password"] as String?,
                    ),
                    beforeRun: () {
                      context.clearSnackBars();
                      context.showSnackBar(SnackBar(
                        content: Text("Logging in..."),
                      ));
                    },
                    afterRun: () {
                      context.clearSnackBars();
                      switch (accountSession.accountSession.state) {
                        case ProcessState.successful:
                          context.showSnackBar(SnackBar(
                            content: Text("Successfully login!"),
                          ));
                          break;
                        case ProcessState.failed:
                        case ProcessState.notRunYet:
                          context.showSnackBar(SnackBar(
                            content: Text("Login failed!"),
                          ));
                          break;
                        default:
                          break;
                      }
                    });
              },
            ),
    );
  }
}
