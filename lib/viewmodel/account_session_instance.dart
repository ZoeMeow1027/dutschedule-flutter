import 'dart:developer';

import 'package:dutwrapper/account_object.dart';
import 'package:dutwrapper/account_session_object.dart';
import 'package:flutter/material.dart';

import '../model/process_state.dart';
import '../model/school_year.dart';
import '../model/variable_state.dart';
import '../repository/dut_account_repository.dart';
import 'base_view_model.dart';

class AccountSessionInstance extends ChangeNotifier with BaseViewModel {
  late DUTAccountRepository accRepo;

  @override
  Future<void> initializing() async {
    accRepo = DUTAccountRepository();
  }

  AuthInfo? authInfo;
  SchoolYear schoolYear = SchoolYear(year: 21, semester: 3);
  var accountSession = VariableState<AccountSession>();
  var subjectInformationList = VariableListState<SubjectInformation>();
  var subjectFeeList = VariableListState<SubjectFee>();
  var studentInformation = VariableState<StudentInformation>();
  var trainingResult = VariableState<TrainingResult>();

  Future<void> reLogin({
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (authInfo == null) {
      log("[Account] [Session - ReLogin] Running denied because no auth available. Logout and try again.");
      return;
    }
    if (accountSession.state == ProcessState.running) {
      log("[Account] [Session - ReLogin] Running denied because account session is running another task...");
      return;
    }

    log("[Account] [Session - ReLogin] Calling Account - Login...");
    login(
      authInfo: authInfo!,
      beforeRun: beforeRun,
      afterRun: afterRun,
      forceRequest: forceRequest,
    );
  }

  Future<void> login({
    required AuthInfo authInfo,
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data != null) {
      log("[Account] [Session - Login] Running denied because of existing account. Logout and try again.");
      return;
    }
    if (accountSession.state == ProcessState.running) {
      log("[Account] [Session - Login] Running denied because account session is running another task...");
      return;
    }

    accountSession.state = ProcessState.running;
    notifyListeners();
    beforeRun?.call();

    log("[Account] [Session - Login] Running...");
    try {
      final session = await accRepo.login(account: authInfo);
      accountSession.data = session;
      this.authInfo = authInfo;
      accountSession.state = ProcessState.successful;
      log("[Account] [Session - Login] Running successful!");
      log("[Account] [Session - Login] Session ID: ${session.sessionId}");
    } catch (ex) {
      accountSession.state = ProcessState.notRunYet;
      log("[Account] [Session - Login] Running failed!");
    } finally {
      accountSession.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Account] [Session - Login] End run.");
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
      log("[Account] [Session - Logout] Running denied because no available account session.");
      return;
    }
    if (accountSession.state == ProcessState.running) {
      log("[Account] [Session - Logout] Running denied because account session is running another task...");
      return;
    }

    beforeRun?.call();

    log("[Account] [Session - Logout] Running...");
    try {
      if (accountSession.data != null) {
        accountSession.state = ProcessState.running;
        notifyListeners();

        // Logout account
        accRepo.logout(session: accountSession.data!);
        accountSession.data = null;
        accountSession.state = ProcessState.notRunYet;
        log("[Account] [Session - Logout] Running successful!");

        // Clear old data from another variables
        subjectInformationList.resetValue();
        subjectFeeList.resetValue();
        studentInformation.resetValue();
        log("[Account] [Session - Logout] Cleared all cached data.");
      } else {
        log("[Account] [Session - Logout] It looks like you don't have any account session.");
      }
    } catch (ex) {
      accountSession.state = ProcessState.failed;
      log("[Account] [Session - Logout] Running failed!");
    } finally {
      accountSession.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Account] [Session - Logout] End run.");
      notifyListeners();
      afterRun?.call();
    }
  }

  Future<void> fetchSubjectInformation({
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data == null) {
      log("[Account] [Subject information] Running denied because no available account session.");
      return;
    }
    if (accountSession.state == ProcessState.running) {
      log("[Account] [Subject information] Running denied because account session is running another task...");
      return;
    }
    if (subjectInformationList.state == ProcessState.running) {
      log("[Account] [Subject information] Running denied because of another task itself...");
      return;
    }

    beforeRun?.call();

    try {
      subjectInformationList.state = ProcessState.running;
      notifyListeners();
      log("[Account] [Subject information] Running...");

      var data = await accRepo.fetchSubjectInformation(
        session: accountSession.data!,
        year: schoolYear.year,
        semester: schoolYear.semester,
      );

      subjectInformationList.data.clear();
      subjectInformationList.data.addAll(data);

      subjectInformationList.state = ProcessState.successful;
      log("[Account] [Subject information] Running successful!");
    } catch (ex) {
      subjectInformationList.state = ProcessState.failed;
      log("[Account] [Subject information] Running failed!");
    } finally {
      subjectInformationList.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Account] [Subject information] End run.");
      notifyListeners();
      afterRun?.call();
    }
  }

  Future<void> fetchStudentInformation({
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data == null) {
      log("[Account] [Student information] Running denied because no available account session.");
      return;
    }
    if (accountSession.state == ProcessState.running) {
      log("[Account] [Student information] Running denied because account session is running another task...");
      return;
    }
    if (studentInformation.state == ProcessState.running) {
      log("[Account] [Student information] Running denied because of another task itself...");
      return;
    }
    beforeRun?.call();

    try {
      studentInformation.state = ProcessState.running;
      notifyListeners();
      log("[Account] [Student information] Running...");

      var data = await accRepo.fetchStudentInformation(
        session: accountSession.data!,
      );
      studentInformation.data = data;
      studentInformation.state = ProcessState.successful;
      log("[Account] [Student information] Running successful!");
    } catch (ex) {
      studentInformation.state = ProcessState.failed;
      log("[Account] [Student information] Running failed!");
    } finally {
      studentInformation.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Account] [Student information] End run.");
      notifyListeners();
      afterRun?.call();
    }
  }

  Future<void> fetchSubjectFee({
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data == null) {
      log("[Account] [Subject fee] Running denied because no available account session.");
      return;
    }
    if (accountSession.state == ProcessState.running) {
      log("[Account] [Subject fee] Running denied because account session is running another task...");
      return;
    }
    if (subjectFeeList.state == ProcessState.running) {
      log("[Account] [Subject fee] Running denied because of another task itself...");
      return;
    }
    beforeRun?.call();

    try {
      subjectFeeList.state = ProcessState.running;
      notifyListeners();
      log("[Account] [Subject fee] Running...");

      var data = await accRepo.fetchSubjectFee(
        session: accountSession.data!,
        year: schoolYear.year,
        semester: schoolYear.semester,
      );
      subjectFeeList.data.clear();
      subjectFeeList.data.addAll(data);

      subjectFeeList.state = ProcessState.successful;
      log("[Account] [Subject fee] Running successful!");
    } catch (ex) {
      subjectFeeList.state = ProcessState.failed;
      log("[Account] [Subject fee] Running failed!");
    } finally {
      subjectFeeList.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Account] [Subject fee] End run.");
      notifyListeners();
      afterRun?.call();
    }
  }

  Future<void> fetchTrainingResult({
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data == null) {
      log("[Account] [Student information] Running denied because no available account session.");
      return;
    }
    if (accountSession.state == ProcessState.running) {
      log("[Account] [Training result] Running denied because account session is running another task...");
      return;
    }
    if (trainingResult.state == ProcessState.running) {
      log("[Account] [Training result] Running denied because of another task itself...");
      return;
    }

    beforeRun?.call();

    try {
      trainingResult.state = ProcessState.running;
      notifyListeners();
      log("[Account] [Training result] Running...");

      var data = await accRepo.fetchTrainingResult(session: accountSession.data!);
      trainingResult.data = data;

      trainingResult.state = ProcessState.successful;
      log("[Account] [Training result] Running successful!");
    } catch (ex) {
      trainingResult.state = ProcessState.failed;
      log("[Account] [Training result] Running failed!");
    } finally {
      trainingResult.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Account] [Training result] End run.");
      notifyListeners();
      afterRun?.call();
    }
  }
}
