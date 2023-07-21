import 'package:dutschedule/screens/mainscreen_account/login_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'not_logged_in.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<StatefulWidget> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab>
    with AutomaticKeepAliveClientMixin<AccountTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: AccountNotLoggedInView(
        onClicked: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return AccountLoginBottomSheet(
                  onClickLogin: (user, pass, remember) {
                    // TODO: Login here!
                  },
                );
              });
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
