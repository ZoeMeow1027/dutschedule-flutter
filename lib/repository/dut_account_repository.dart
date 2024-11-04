import 'package:dutwrapper/account_object.dart';
import 'package:dutwrapper/account_session_object.dart';
import 'package:dutwrapper/accounts.dart';
import 'package:dutwrapper/enums.dart';

class DUTAccountRepository {
  Future<AccountSession> login({required AuthInfo account}) async {
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
      throw Exception("Failed while logging in!");
    }
  }

  Future<void> logout({required AccountSession session}) async {
    await Accounts.logout(session: session);
  }

  Future<bool> checkLoggedIn({required AccountSession session}) async {
    var data = await Accounts.isLoggedIn(session: session);
    return data == LoginStatus.loggedIn;
  }

  Future<List<SubjectInformation>> fetchSubjectInformation({
    required AccountSession session,
    required int year,
    required int semester,
  }) async {
    var data = await Accounts.fetchSubjectInformation(session: session, year: year, semester: semester);
    return data;
  }

  Future<List<SubjectFee>> fetchSubjectFee({
    required AccountSession session,
    required int year,
    required int semester,
  }) async {
    var data = await Accounts.fetchSubjectFee(session: session, year: year, semester: semester);
    return data;
  }

  Future<StudentInformation> fetchStudentInformation({
    required AccountSession session,
  }) async {
    return await Accounts.fetchStudentInformation(session: session);
  }

  Future<TrainingResult> fetchTrainingResult({
    required AccountSession session,
  }) async {
    return await Accounts.fetchTrainingResult(session: session);
  }
}
