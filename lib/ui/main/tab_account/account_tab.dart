import 'package:dutschedule/model/dut_account.dart';
import 'package:dutschedule/repository/dut_account_repository.dart';
import 'package:dutschedule/ui/main/tab_account/not_logged_in.dart';
import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:dutwrapper/account_session_object.dart';
import 'package:flutter/material.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<StatefulWidget> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab>
    with AutomaticKeepAliveClientMixin<AccountTab> {
  AccountSession? _session;
  String _username = "";
  String _password = "";
  bool _rememberLogin = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: AccountNotLoggedInView(
        username: _username,
        password: _password,
        rememberLogin: _rememberLogin,
        isProcessing: _isProcessing,
        onAuthInfoChanged: (user, pass, remember) {
          setState(() {
            _username = user;
            _password = pass;
            _rememberLogin = remember;
          });
        },
        loginRequested: () async {
          // TODO: Login here!
          setState(() {
            _isProcessing = true;
          });
          context.clearSnackBars();
          context.showSnackBar(SnackBar(
            content: Text("Logging in..."),
          ));

          try {
            DUTAccount acc = DUTAccount(
              username: _username,
              password: _password,
            );
            DUTAccountRepository acc1 = DUTAccountRepository();
            var session = await acc1.login(account: acc);
            setState(() {
              _session = session;
            });

            context.clearSnackBars();
            context
                .showSnackBar(SnackBar(content: Text("Successfully login!")));
          } catch (ex) {
            setState(() {
              _session = null;
            });
            context.clearSnackBars();
            context.showSnackBar(SnackBar(content: Text("Login failed!")));
          } finally {
            setState(() {
              _isProcessing = false;
            });
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
