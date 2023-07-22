import 'package:dutwrapper/account.dart';
import 'package:dutwrapper/model/enums.dart';

import '../model/dut_account.dart';
import '../model/exceptions/dut_account_login_exception.dart';

class DUTAccountRepository {
  Future<bool> loginWithSessionID({
    required String sessionId,
    required DUTAccount account,
  }) async {
    var data = await Account.login(
      sessionId: sessionId,
      userId: account.username,
      password: account.password,
    );
    return data.requestCode == RequestCode.successful;
  }

  Future<String> login({required DUTAccount account}) async {
    var sGetID = await Account.generateSessionID();
    var data = await Account.login(
      sessionId: sGetID.sessionId,
      userId: account.username,
      password: account.password,
    );
    if (data.requestCode == RequestCode.successful) {
      return sGetID.sessionId;
    } else {
      throw DUTAccountLoginException(
        requestCode: data.requestCode,
      );
    }
  }

  Future<bool> checkLoggedIn({required String sessionId}) async {
    var data = await Account.isLoggedIn(sessionId: sessionId);
    return data.requestCode == RequestCode.successful;
  }
}
