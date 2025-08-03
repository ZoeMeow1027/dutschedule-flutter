import 'package:dutwrapper/account_object.dart';
import 'package:dutwrapper/account_session_object.dart';

import '../global_variables.dart';
import '../model/enum/app_log_level.dart';
import '../model/enum/process_state.dart';
import '../model/school_year.dart';
import '../model/variable_state.dart';
import '../repository/dut_account_repository.dart';
import '../repository/storage_repository.dart';
import '../utils/app_utils.dart';
import 'base_view_model.dart';

class AccountSessionInstance extends BaseViewModel {
  late DUTAccountRepository accRepo;

  AccountSessionInstance();

  AccountSessionInstance.fromPreviousSettings({
    Map<String, dynamic>? accountSessionJson,
    Map<String, dynamic>? accountCacheJson,
    SchoolYear? schoolYear,
  }) {
    if (schoolYear != null) {
      this.schoolYear = schoolYear;
    }
    if (accountSessionJson != null) {
      _fromMapAccountSession(accountSessionJson);
    }
    if (accountCacheJson != null) {
      _fromMapAccountCache(accountCacheJson);
    }
  }

  @override
  void initializing() {
    accRepo = DUTAccountRepository();
  }

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
        tag: 'Account Session',
        subTag: 'Relogin',
        message: 'Denied this task because no auth available. Logout and try again.',
      );
      return;
    }
    if (accountSession.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Relogin',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.debug,
      tag: 'Account Session',
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
        tag: 'Account Session',
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
        tag: 'Account Session',
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
      tag: 'Account Session',
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
        tag: 'Account Session',
        subTag: 'Login',
        message: 'Task done successfully!',
      );
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'Account Session',
        subTag: 'Login',
        message: 'Session ID: ${session.sessionId}',
      );
    } catch (ex) {
      accountSession.state = authInfo != null ? ProcessState.notRunYet : ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'Account Session',
        subTag: 'Login',
        message: 'Task failed!',
      );
    } finally {
      accountSession.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'Account Session',
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
        tag: 'Account Session',
        subTag: 'Logout',
        message: 'Denied this task because no sessions available.',
      );
      return;
    }
    if (accountSession.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Logout',
        message: 'Denied this task because account session is running another task...',
      );
      return;
    }

    beforeRun?.call();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'Account Session',
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
          tag: 'Account Session',
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
          tag: 'Account Session',
          subTag: 'Logout',
          message: 'Cleared all cached data.',
        );
      } else {
        AppUtils.showLogToDebug(
          resultTag: AppLogLevel.info,
          tag: 'Account Session',
          subTag: 'Logout',
          message: "Looks like you don't have any account session.",
        );
      }
    } catch (ex) {
      accountSession.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'Account Session',
        subTag: 'Logout',
        message: 'Task failed!',
      );
    } finally {
      accountSession.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'Account Session',
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
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Subject Information',
        message: 'Denied this task because no sessions available.',
      );
      return;
    }
    if (accountSession.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Subject Information',
        message: 'Denied this task because account session is running another task...',
      );
      return;
    }
    if (subjectInformationList.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Subject Information',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }
    if (!subjectInformationList.isSuccessfulRequestExpired() && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Subject Information',
        message: 'Denied this task because of timeout '
            '(${GlobalVariables.requestExpiredDuration / 1000 / 60} minute(s)). '
            'Set "forceRequest" to true to bypass it.',
      );
      return;
    }
    beforeRun?.call();

    try {
      subjectInformationList.state = ProcessState.running;
      _cacheChanged();
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'Account Session',
        subTag: 'Subject Information',
        message: 'Running...',
      );

      var data = await accRepo.fetchSubjectInformation(
        session: accountSession.data!,
        year: schoolYear.year,
        semester: schoolYear.semester,
      );

      subjectInformationList.data.clear();
      subjectInformationList.data.addAll(data);

      subjectInformationList.state = ProcessState.successful;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'Account Session',
        subTag: 'Subject Information',
        message: 'Task done successfully!',
      );
    } catch (ex) {
      subjectInformationList.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'Account Session',
        subTag: 'Subject Information',
        message: 'Task failed!',
      );
    } finally {
      subjectInformationList.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Subject Information',
        message: 'Done task.',
      );
      _cacheChanged();
      afterRun?.call();
    }
  }

  Future<void> fetchStudentInformation({
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data == null) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Student Information',
        message: 'Denied this task because no sessions available.',
      );
      return;
    }
    if (accountSession.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Student Information',
        message: 'Denied this task because account session is running another task...',
      );
      return;
    }
    if (subjectInformationList.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Student Information',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }
    if (!subjectInformationList.isSuccessfulRequestExpired() && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Student Information',
        message: 'Denied this task because of timeout '
            '(${GlobalVariables.requestExpiredDuration / 1000 / 60} minute(s)). '
            'Set "forceRequest" to true to bypass it.',
      );
      return;
    }
    beforeRun?.call();

    try {
      studentInformation.state = ProcessState.running;
      _cacheChanged();
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Student Information',
        message: 'Running...',
      );

      var data = await accRepo.fetchStudentInformation(
        session: accountSession.data!,
      );
      studentInformation.data = data;
      studentInformation.state = ProcessState.successful;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Student Information',
        message: 'Task done successfully!',
      );
    } catch (ex) {
      studentInformation.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Student Information',
        message: 'Task failed!',
      );
    } finally {
      studentInformation.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Student Information',
        message: 'Done task.',
      );
      _cacheChanged();
      afterRun?.call();
    }
  }

  Future<void> fetchSubjectFee({
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data == null) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Subject Fee',
        message: 'Denied this task because no sessions available.',
      );
      return;
    }
    if (accountSession.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Subject Fee',
        message: 'Denied this task because account session is running another task...',
      );
      return;
    }
    if (subjectInformationList.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Subject Fee',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }
    if (!subjectInformationList.isSuccessfulRequestExpired() && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Subject Fee',
        message: 'Denied this task because of timeout '
            '(${GlobalVariables.requestExpiredDuration / 1000 / 60} minute(s)). '
            'Set "forceRequest" to true to bypass it.',
      );
      return;
    }
    beforeRun?.call();

    try {
      subjectFeeList.state = ProcessState.running;
      _cacheChanged();
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'Account Session',
        subTag: 'Subject Fee',
        message: 'Running...',
      );

      var data = await accRepo.fetchSubjectFee(
        session: accountSession.data!,
        year: schoolYear.year,
        semester: schoolYear.semester,
      );
      subjectFeeList.data.clear();
      subjectFeeList.data.addAll(data);

      subjectFeeList.state = ProcessState.successful;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'Account Session',
        subTag: 'Subject Fee',
        message: 'Task done successfully!',
      );
    } catch (ex) {
      subjectFeeList.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'Account Session',
        subTag: 'Subject Fee',
        message: 'Task failed!',
      );
    } finally {
      subjectFeeList.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Subject Fee',
        message: 'Done task.',
      );
      _cacheChanged();
      afterRun?.call();
    }
  }

  Future<void> fetchTrainingResult({
    Function()? beforeRun,
    Function()? afterRun,
    bool forceRequest = false,
  }) async {
    if (accountSession.data == null) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Training Result',
        message: 'Denied this task because no sessions available.',
      );
      return;
    }
    if (accountSession.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Training Result',
        message: 'Denied this task because account session is running another task...',
      );
      return;
    }
    if (subjectInformationList.state == ProcessState.running) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Training Result',
        message: 'Denied this task because another same task is running...',
      );
      return;
    }
    if (!subjectInformationList.isSuccessfulRequestExpired() && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Training Result',
        message: 'Denied this task because of timeout '
            '(${GlobalVariables.requestExpiredDuration / 1000 / 60} minute(s)). '
            'Set "forceRequest" to true to bypass it.',
      );
      return;
    }
    beforeRun?.call();

    try {
      trainingResult.state = ProcessState.running;
      _cacheChanged();
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'Account Session',
        subTag: 'Training Result',
        message: 'Running...',
      );

      var data = await accRepo.fetchTrainingResult(session: accountSession.data!);
      trainingResult.data = data;

      trainingResult.state = ProcessState.successful;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'Account Session',
        subTag: 'Training Result',
        message: 'Task done successfully!',
      );
    } catch (ex) {
      trainingResult.state = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'Account Session',
        subTag: 'Training Result',
        message: 'Task failed!',
      );
    } finally {
      trainingResult.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'Account Session',
        subTag: 'Training Result',
        message: 'Done task.',
      );
      _cacheChanged();
      afterRun?.call();
    }
  }

  bool _pendingChanges = false;

  void _settingsChanged() async {
    if (!isInitialized) {
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
      tag: 'Account Session',
      subTag: 'Session Instance',
      message: 'Modified changes! Saving...',
    );
    StorageRepository.saveAccountSession(accountSession: _toMapAccountSession());

    _pendingChanges = false;
    notifyListeners();
  }

  void _cacheChanged() async {
    if (!isInitialized) {
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
      tag: 'Account Session',
      subTag: 'Session Cache',
      message: 'Modified changes! Saving...',
    );
    StorageRepository.saveAccountCache(accountCache: _toMapAccountCache());

    _pendingChanges = false;
    notifyListeners();
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

  Map<String, dynamic> _toMapAccountCache() {
    return {
      'account.username': authInfo?.username,
      'account.schoolyear': schoolYear.toJson(),
      'account.cache.subjectinformation': {
        'lastrequest': subjectInformationList.lastRequest,
        'data': subjectInformationList.data.map((p) => p.toMap()).toList(),
      },
      'account.cache.subjectfee': {
        'lastrequest': subjectFeeList.lastRequest,
        'data': subjectFeeList.data.map((p) => p.toMap()).toList(),
      },
      'account.cache.studentinformation': {
        'lastrequest': studentInformation.lastRequest,
        'data': studentInformation.data?.toMap(),
      },
      'account.cache.trainingresult': {
        'lastrequest': trainingResult.lastRequest,
        'data': trainingResult.data?.toMap(),
      },
    };
  }

  void _fromMapAccountCache(Map<String, dynamic> data) {
    // If `authInfo` is null or mismatch with this cache, prevent load from cache.
    if (authInfo == null) {
      return;
    }
    // Check if cache is mismatch for prevent loading.
    final cacheUsername = data['account.username'] as String?;
    if (authInfo?.username != null &&
        cacheUsername != null &&
        cacheUsername.compareTo(authInfo?.username ?? '') != 0) {
      return;
    }

    schoolYear = SchoolYear.fromJson((data['account.schoolyear'] as Map<String, dynamic>?) ?? {});
    // Load subject information list.
    final dataSubjectInformation = (data['account.cache.subjectinformation'] as Map<String, dynamic>?) ?? {};
    subjectInformationList = VariableListState<SubjectInformation>.from(
      lastRequest: (dataSubjectInformation['lastrequest'] as int?) ?? 0,
      data:
          (dataSubjectInformation['data'] as List<dynamic>? ?? []).map((p) => SubjectInformation.fromMap(p)).toList(),
      parameters: {},
    );
    // Load subject fee list.
    final dataSubjectFee = (data['account.cache.subjectfee'] as Map<String, dynamic>?) ?? {};
    subjectFeeList = VariableListState<SubjectFee>.from(
      lastRequest: (dataSubjectFee['lastrequest'] as int?) ?? 0,
      data: (dataSubjectFee['data'] as List<dynamic>? ?? []).map((p) => SubjectFee.fromMap(p)).toList(),
      parameters: {},
    );
    // Load student information
    final dataStudentInformation = (data['account.cache.studentinformation'] as Map<String, dynamic>?) ?? {};
    studentInformation = VariableState<StudentInformation>.from(
      lastRequest: (dataStudentInformation['lastrequest'] as int?) ?? 0,
      data: StudentInformation.fromMap((dataStudentInformation['data'] as Map<String, dynamic>?) ?? {}),
      parameters: {},
    );
    // Load training result
    final dataTrainingResult = (data['account.cache.trainingresult'] as Map<String, dynamic>?) ?? {};
    trainingResult = VariableState<TrainingResult>.from(
      lastRequest: (dataTrainingResult['lastrequest'] as int?) ?? 0,
      data: TrainingResult.fromMap((dataTrainingResult['data'] as Map<String, dynamic>?) ?? {}),
      parameters: {},
    );
  }
}
