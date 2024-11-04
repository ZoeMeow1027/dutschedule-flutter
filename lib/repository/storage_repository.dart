import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dutwrapper/account_session_object.dart';
import 'package:path_provider/path_provider.dart';

class StorageRepository {
  static Future<File> _localFile({required String fileName}) async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/$fileName');
  }

  static Future<String> getWebViewPath() async {
    final directory = await getApplicationSupportDirectory();
    return '${directory.path}/WebView';
  }

  static Future<void> saveAccount({required AccountSession session}) async {
    final data = await _localFile(fileName: 'account.json');
    await data.writeAsString(jsonEncode(session.toJson()));
  }

  static Future<AccountSession> loadAccountSession() async {
    final data = await _localFile(fileName: 'account.session.json');
    final dataString = await data.readAsString();
    final content = jsonDecode(dataString);
    return AccountSession.fromJson(content);
  }
}
