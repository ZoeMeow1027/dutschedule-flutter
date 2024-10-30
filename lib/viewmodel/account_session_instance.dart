import 'dart:developer';

import 'package:dutwrapper/account_session_object.dart';
import 'package:flutter/material.dart';

import '../model/process_state.dart';
import '../model/variable_state.dart';
import '../repository/dut_account_repository.dart';

class AccountSessionInstance extends ChangeNotifier {
  var accountSession = VariableState<AccountSession>();

  Future<void> login({
    required AuthInfo authInfo,
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data != null) {
      log("Account session - Logout: Running denied because of existing account. Logout and try again.");
      return;
    }
    if (accountSession.state == ProcessState.running) {
      log("Account session - Login: Running denied because of running...");
      return;
    }

    accountSession.state = ProcessState.running;
    notifyListeners();
    beforeRun?.call();

    log("Account session - Login: Running...");
    try {
      DUTAccountRepository accRepo = DUTAccountRepository();
      final session = await accRepo.login(account: authInfo);
      accountSession.data = session;
      accountSession.state = ProcessState.successful;
      log("Account session - Login: Running successful!");
    } catch (ex) {
      accountSession.state = ProcessState.notRunYet;
      log("Account session - Login: Running failed!");
    } finally {
      accountSession.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("Account session - Login: End run.");
      notifyListeners();
      afterRun?.call();
    }
  }

  Future<void> logout({
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data == null) {
      log("Account session - Logout: Running denied because no available account session.");
      return;
    }
    if (accountSession.state == ProcessState.running) {
      log("Account session - Logout: Running denied because of running...");
      return;
    }

    beforeRun?.call();

    log("Account session - Logout: Running...");
    try {
      DUTAccountRepository accRepo = DUTAccountRepository();
      if (accountSession.data != null) {
        accountSession.state = ProcessState.running;
        notifyListeners();

        accRepo.logout(session: accountSession.data!);
        accountSession.data = null;
        accountSession.state = ProcessState.notRunYet;
        log("Account session - Logout: Running successful!");
      } else {
        log("Account session - Logout: It looks like you don't have any account session.");
      }
    } catch (ex) {
      accountSession.state = ProcessState.failed;
      log("Account session - Logout: Running failed!");
    } finally {
      accountSession.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("Account session - Logout: End run.");
      notifyListeners();
      afterRun?.call();
    }
  }
}
