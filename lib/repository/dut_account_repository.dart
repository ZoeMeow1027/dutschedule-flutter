import 'package:dutwrapper/account_session_object.dart';
import 'package:dutwrapper/accounts.dart';
import 'package:dutwrapper/enums.dart';

import '../model/dut_account.dart';
import '../model/exceptions/dut_account_login_exception.dart';

class DUTAccountRepository {
  Future<bool> loginWithSessionID({
    required AccountSession session,
    required DUTAccount account,
  }) async {
    await Accounts.login(
      session: session,
      authInfo: AuthInfo(username: account.username, password: account.password,),
    );
    return await checkLoggedIn(session: session);
  }

  Future<AccountSession> login({required DUTAccount account}) async {
    var sGetID = await Accounts.generateNewSession();
    await Accounts.login(
      session: sGetID,
      authInfo: AuthInfo(
        username: account.username,
        password: account.password,
      ),
    );
    if (await checkLoggedIn(session: sGetID)) {
      return sGetID;
    } else {
      throw DUTAccountLoginException(
        requestCode: RequestCode.failed,
      );
    }
  }

  Future<bool> checkLoggedIn({required AccountSession session}) async {
    var data = await Accounts.isLoggedIn(session: session);
    return data == LoginStatus.loggedIn;
  }
}
