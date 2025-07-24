import 'dart:developer';

import 'package:dutwrapper/account_object.dart';
import 'package:dutwrapper/account_session_object.dart';

import '../global_variables.dart';
import '../model/enum/process_state.dart';
import '../model/school_year.dart';
import '../model/core/variable_state.dart';
import '../repository/dut_account_repository.dart';
import '../repository/storage_repository.dart';
import '../utils/app_utils.dart';
import 'base_view_model.dart';

class AccountSessionInstance extends BaseViewModel {
  late DUTAccountRepository accRepo;

  AccountSessionInstance();

  AccountSessionInstance.fromPreviousSettings({Map<String, dynamic>? accountSessionJson}) {
    if (accountSessionJson != null) {
      _fromMapAccountSession(accountSessionJson);
    }
    _isSettingsInitialized = true;
  }

  @override
  void initializing() {
    accRepo = DUTAccountRepository();
    _isSettingsInitialized = true;
  }

  bool _isSettingsInitialized = false;

  @override
  void timerAction() {}

  AuthInfo? authInfo;
  SchoolYear schoolYear = SchoolYear(year: 21, semester: 3);
  var accountSession = VariableState<AccountSession>();
  var subjectInformationList = VariableListState<SubjectInformation>();
  var subjectFeeList = VariableListState<SubjectFee>();
  var studentInformation = VariableState<StudentInformation>();
  var trainingResult = VariableState<TrainingResult>();

  Future<void> reLogin({
    Function()? beforeRun,
    Function(bool)? afterRun,
    bool forceRequest = false,
  }) async {
    if (authInfo == null) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'AccountSession',
        subTag: 'Relogin',
        message: 'Denied this task because no auth available. Logout and try again.',
      );
      return;
    }
    if (accountSession.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'AccountSession',
        subTag: 'Relogin',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'AccountSession',
      subTag: 'Relogin',
      message: 'Calling function login()...',
    );
    login(
      beforeRun: beforeRun,
      afterRun: afterRun,
      forceRequest: forceRequest,
    );
  }

  Future<void> login({
    AuthInfo? authInfo,
    Function()? beforeRun,
    Function(bool)? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data == null && authInfo == null) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'AccountSession',
        subTag: 'Login',
        message: 'Denied this task because no sessions available. Please login with "authInfo" parameters',
      );
      return;
    }
    // if (accountSession.data != null && authInfo != null) {
    //   log("[Account] [Session - Login] Running denied because of existing session. Logout and try again.");
    //   return;
    // }
    if (accountSession.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'AccountSession',
        subTag: 'Login',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }

    accountSession.state = ProcessState.running;
    _settingsChanged();
    beforeRun?.call();

    await Future.delayed(Duration(milliseconds: 500));

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'AccountSession',
      subTag: 'Login',
      message: 'Running...',
    );
    try {
      final session = await accRepo.login(account: authInfo!);
      accountSession.data = session;
      this.authInfo = authInfo;
      accountSession.state = ProcessState.successful;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'AccountSession',
        subTag: 'Login',
        message: 'Task done successfully!',
      );
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'AccountSession',
        subTag: 'Login',
        message: 'Session ID: ${session.sessionId}',
      );
    } catch (ex) {
      accountSession.state = authInfo != null ? ProcessState.notRunYet : ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'AccountSession',
        subTag: 'Login',
        message: 'Task failed!',
      );
    } finally {
      accountSession.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'AccountSession',
        subTag: 'Login',
        message: 'Done task.',
      );
      _settingsChanged();
      afterRun?.call(accountSession.state == ProcessState.successful);
    }
  }

  Future<void> logout({
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data == null) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'AccountSession',
        subTag: 'Logout',
        message: 'Denied this task because no sessions available.',
      );
      return;
    }
    if (accountSession.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'AccountSession',
        subTag: 'Logout',
        message: 'Denied this task because account session is running another task...',
      );
      return;
    }

    beforeRun?.call();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'AccountSession',
      subTag: 'Logout',
      message: 'Running...',
    );
    try {
      if (accountSession.data != null) {
        // Logout account
        authInfo = null;
        if (accountSession.data?.sessionId != null) {
          accRepo.logout(session: accountSession.data!);
        }
        accountSession.resetValue();
        AppUtils.showLogToDebug(
          resultTag: AppLogLevel.info,
          tag: 'AccountSession',
          subTag: 'Logout',
          message: 'Task done successfully!',
        );

        // Clear old data from another variables
        subjectInformationList.resetValue();
        subjectFeeList.resetValue();
        studentInformation.resetValue();
        trainingResult.resetValue();
        AppUtils.showLogToDebug(
          resultTag: AppLogLevel.info,
          tag: 'AccountSession',
          subTag: 'Logout',
          message: 'Cleared all cached data.',
        );
      } else {
        AppUtils.showLogToDebug(
          resultTag: AppLogLevel.info,
          tag: 'AccountSession',
          subTag: 'Logout',
          message: "Looks like you don't have any account session.",
        );
      }
    } catch (ex) {
      accountSession.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'AccountSession',
        subTag: 'Logout',
        message: 'Task failed!',
      );
    } finally {
      accountSession.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'AccountSession',
        subTag: 'Logout',
        message: 'Done task.',
      );
      _settingsChanged();
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
    if (!subjectInformationList.isSuccessfulRequestExpired() && !forceRequest) {
      log("[Account] [Subject information] Task start failed because of timeout (${GlobalVariables.requestExpiredDuration / 1000 / 60} minute(s)). Set forceRequest to true to bypass it.");
      return;
    }
    beforeRun?.call();

    try {
      subjectInformationList.state = ProcessState.running;
      _settingsChanged();
      log("[Account] [Subject information] Running...");

      var data = await accRepo.fetchSubjectInformation(
        session: accountSession.data!,
        year: schoolYear.year,
        semester: schoolYear.semester,
      );

      subjectInformationList.data.clear();
      subjectInformationList.data.addAll(data);

      subjectInformationList.state = ProcessState.successful;
      log("[Account] [Subject information] Task successful!");
    } catch (ex) {
      subjectInformationList.state = ProcessState.failed;
      log("[Account] [Subject information] Task failed!");
    } finally {
      subjectInformationList.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Account] [Subject information] End run.");
      _settingsChanged();
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
    if (!studentInformation.isSuccessfulRequestExpired() && !forceRequest) {
      log("[Account] [Student information] Task start failed because of timeout (${GlobalVariables.requestExpiredDuration / 1000 / 60} minute(s)). Set forceRequest to true to bypass it.");
      return;
    }
    beforeRun?.call();

    try {
      studentInformation.state = ProcessState.running;
      _settingsChanged();
      log("[Account] [Student information] Running...");

      var data = await accRepo.fetchStudentInformation(
        session: accountSession.data!,
      );
      studentInformation.data = data;
      studentInformation.state = ProcessState.successful;
      log("[Account] [Student information] Task successful!");
    } catch (ex) {
      studentInformation.state = ProcessState.failed;
      log("[Account] [Student information] Task failed!");
    } finally {
      studentInformation.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Account] [Student information] End run.");
      _settingsChanged();
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
    if (!subjectFeeList.isSuccessfulRequestExpired() && !forceRequest) {
      log("[Account] [Subject fee] Task start failed because of timeout (${GlobalVariables.requestExpiredDuration / 1000 / 60} minute(s)). Set forceRequest to true to bypass it.");
      return;
    }
    beforeRun?.call();

    try {
      subjectFeeList.state = ProcessState.running;
      _settingsChanged();
      log("[Account] [Subject fee] Running...");

      var data = await accRepo.fetchSubjectFee(
        session: accountSession.data!,
        year: schoolYear.year,
        semester: schoolYear.semester,
      );
      subjectFeeList.data.clear();
      subjectFeeList.data.addAll(data);

      subjectFeeList.state = ProcessState.successful;
      log("[Account] [Subject fee] Task successful!");
    } catch (ex) {
      subjectFeeList.state = ProcessState.failed;
      log("[Account] [Subject fee] Task failed!");
    } finally {
      subjectFeeList.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Account] [Subject fee] End run.");
      _settingsChanged();
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
    if (!trainingResult.isSuccessfulRequestExpired() && !forceRequest) {
      log("[Account] [Training result] Task start failed because of timeout (${GlobalVariables.requestExpiredDuration / 1000 / 60} minute(s)). Set forceRequest to true to bypass it.");
      return;
    }
    beforeRun?.call();

    try {
      trainingResult.state = ProcessState.running;
      _settingsChanged();
      log("[Account] [Training result] Running...");

      var data = await accRepo.fetchTrainingResult(session: accountSession.data!);
      trainingResult.data = data;

      trainingResult.state = ProcessState.successful;
      log("[Account] [Training result] Task successful!");
    } catch (ex) {
      trainingResult.state = ProcessState.failed;
      log("[Account] [Training result] Task failed!");
    } finally {
      trainingResult.lastRequest = DateTime.now().millisecondsSinceEpoch;
      log("[Account] [Training result] End run.");
      _settingsChanged();
      afterRun?.call();
    }
  }

  Map<String, dynamic> _toMapAccountSession() {
    return {
      "account.authinfo.username": authInfo?.username,
      "account.authinfo.password": authInfo?.password,
      "account.accountsession.data": accountSession.data?.toMap(),
      "account.accountsession.lastrequest": accountSession.lastRequest,
      "account.accountsession.parameters": accountSession.parameters,
    };
  }

  void _fromMapAccountSession(Map<String, dynamic> data) {
    authInfo = AuthInfo(
      username: data["account.authinfo.username"] as String?,
      password: data["account.authinfo.password"] as String?,
    );
    if (authInfo?.username == null || authInfo?.password == null) {
      authInfo = null;
    }

    accountSession.data = AccountSession.fromMap(data["account.accountsession.data"] as Map<String, dynamic>? ?? {});
    try {
      accountSession.data?.ensureValidLoginForm();
      accountSession.data?.ensureValidSessionId();

      accountSession.state = ProcessState.successful;
      accountSession.lastRequest = (data["account.accountsession.lastrequest"] as int?) ?? 0;
      accountSession.parameters.clear();
      ((data["account.accountsession.parameters"] as Map<String, dynamic>?) ?? {}).forEach((p, q) {
        accountSession.parameters.addAll({p: q});
      });

      // Write account session to debug console.
      // log(json.encode(accountSession.data));
    } catch (ex) {
      accountSession.data = null;
      accountSession.state = ProcessState.notRunYet;
      accountSession.lastRequest = 0;
    }
    _settingsChanged();
  }

  bool _pendingChanges = false;

  void _settingsChanged() async {
    if (!_isSettingsInitialized) {
      return;
    }
    while (_pendingChanges) {
      await Future.delayed(Duration(milliseconds: 100));
      // return;
    }

    _pendingChanges = true;
    notifyListeners();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'AccountSession',
      message: 'Modified changes! Saving...',
    );
    StorageRepository.saveAccountSession(accountSession: _toMapAccountSession());

    _pendingChanges = false;
    notifyListeners();
  }
}
