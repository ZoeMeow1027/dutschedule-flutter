import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/process_state.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/launch_url.dart';
import '../../../utils/theme_tools.dart';
import '../../../viewmodel/account_session_instance.dart';
import '../../../viewmodel/main_view_model.dart';

class AccountNotLoggedInView extends StatelessWidget {
  const AccountNotLoggedInView({
    super.key,
    required this.onAuthInfoChanged,
    required this.loginRequested,
  });

  final Function(String, String, bool) onAuthInfoChanged;
  final Function() loginRequested;

  @override
  Widget build(BuildContext context) {
    final mainViewModel = Provider.of<MainViewModel>(context);
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
                  color: ThemeTool.isAppDarkMode(context) ? Colors.white : Colors.black,
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
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                enabled: accountSession.accountSession.state != ProcessState.running,
                onChanged: (changed) {
                  onAuthInfoChanged(
                    changed,
                    mainViewModel.accountParameter["password"] as String? ?? "",
                    mainViewModel.accountParameter["rememberLogin"] as bool? ?? false,
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
                    mainViewModel.accountParameter["username"] as String? ?? "",
                    changed,
                    mainViewModel.accountParameter["rememberLogin"] as bool? ?? false,
                  );
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).translate("account_login_password"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: accountSession.accountSession.state == ProcessState.running
                    ? null
                    : () {
                        onAuthInfoChanged(
                          mainViewModel.accountParameter["username"] as String? ?? "",
                          mainViewModel.accountParameter["password"] as String? ?? "",
                          !(mainViewModel.accountParameter["rememberLogin"] as bool? ?? false),
                        );
                      },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          onChanged: accountSession.accountSession.state == ProcessState.running
                              ? null
                              : (checked) {
                                  onAuthInfoChanged(
                                    mainViewModel.accountParameter["username"] as String? ?? "",
                                    mainViewModel.accountParameter["password"] as String? ?? "",
                                    checked ?? !(mainViewModel.accountParameter["rememberLogin"] as bool? ?? false),
                                  );
                                },
                          value: mainViewModel.accountParameter["rememberLogin"] as bool? ?? false,
                        ),
                        Text(AppLocalizations.of(context).translate("account_login_rememberpassword"))
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                    launchOwnUrl(
                      "https://github.com/ZoeMeow1027/DutSchedule/wiki/Changing-Password-In-DUT#qu%C3%AAn-m%E1%BA%ADt-kh%E1%BA%A9u",
                      onFailed: () {
                        context.clearSnackBars();
                        context.showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).translate("link_failed"))));
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
