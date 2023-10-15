import 'dart:developer';

import 'package:dutschedule/screens/mainscreen_account/login_bottom_sheet.dart';
import 'package:dutwrapper/account.dart';
import 'package:dutwrapper/model/enums.dart';
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
                onClickLogin: (user, pass, remember) async {
                  // TODO: Login here!
                  var sid = await Account.generateSessionID();
                  var data = await Account.login(
                      sessionId: sid.sessionId, userId: user, password: pass);

                  log(data.sessionId);
                  log(data.statusCode.toString());
                  log(data.requestCode.toString());
                  log(data.data ?? "none");

                  Map<String, dynamic> result = {};

                  result["status"] =
                      data.requestCode == RequestCode.successful ? true : false;
                  result["msg"] = data.requestCode == RequestCode.successful
                      ? "Successfully login!"
                      : "Login failed! Status code: ${data.statusCode}";

                  if (data.requestCode == RequestCode.successful) {
                    Navigator.pop(context);
                  }

                  return result;
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
