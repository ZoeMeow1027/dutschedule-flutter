import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global_variables.dart';
import '../../../model/process_state.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/build_context_extension.dart';
import '../../../viewmodel/account_session_instance.dart';
import 'account_tab.dart';

class AccountNotLoggedInView extends StatelessWidget {
  const AccountNotLoggedInView({
    super.key,
    this.accTemp,
    required this.onAuthInfoChanged,
    required this.loginRequested,
  });

  final AccountLoginTemporary? accTemp;
  final Function(String, String, bool) onAuthInfoChanged;
  final Function() loginRequested;

  @override
  Widget build(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: context.isAppDarkMode() ? Colors.white : Colors.black,
                ),
                children: [
                  WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        AppLocalizations.of(context).translate("account_login_title"),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "\n${AppLocalizations.of(context).translate("account_login_description")}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: TextField(
                enabled: accountSession.accountSession.state != ProcessState.running,
                onChanged: (changed) {
                  onAuthInfoChanged(
                    changed,
                    accTemp?.password ?? "",
                    accTemp?.rememberLogin ?? false,
                  );
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).translate("account_login_username"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                enabled: accountSession.accountSession.state != ProcessState.running,
                onChanged: (changed) {
                  onAuthInfoChanged(
                    accTemp?.username ?? "",
                    changed,
                    accTemp?.rememberLogin ?? false,
                  );
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).translate("account_login_password"),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 10),
            //   child: InkWell(
            //     onTap: accountSession.accountSession.state == ProcessState.running
            //         ? null
            //         : () {
            //             onAuthInfoChanged(
            //               accTemp?.username ?? "",
            //               accTemp?.password ?? "",
            //               !(accTemp?.rememberLogin ?? false),
            //             );
            //           },
            //     child: Container(
            //       alignment: Alignment.centerLeft,
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Checkbox(
            //               onChanged: accountSession.accountSession.state == ProcessState.running
            //                   ? null
            //                   : (checked) {
            //                       onAuthInfoChanged(
            //                         accTemp?.username ?? "",
            //                         accTemp?.password ?? "",
            //                         checked ?? !(accTemp?.rememberLogin ?? false),
            //                       );
            //                     },
            //               value: accTemp?.rememberLogin ?? false,
            //             ),
            //             Text(AppLocalizations.of(context).translate("account_login_rememberpassword"))
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.only(),
              child: FilledButton(
                onPressed: () {
                  loginRequested();
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 18,
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).translate("account_login_actionlogin"),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(AppLocalizations.of(context).translate("account_login_actionforgot")),
                ),
                onTap: () {
                  if (accountSession.accountSession.state != ProcessState.running) {
                    AppUtils.launchOwnUrl(
                      GlobalVariables.repoLinkForgotPassword,
                      onFailed: () {
                        context.showCustomSnackBar(
                          content: Text(AppLocalizations.of(context).translate("link_failed")),
                          dismissOld: true,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
