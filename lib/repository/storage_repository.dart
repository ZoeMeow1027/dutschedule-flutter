import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../model/dut_account.dart';

class StorageRepository {
  static Future<File> _localFile({required String fileName}) async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/$fileName');
  }

  static Future<void> saveAccount({required DUTAccount account}) async {
    final data = await _localFile(fileName: 'account.json');
    await data.writeAsString(jsonEncode(account.toJson()));
  }

  static Future<DUTAccount> loadAccount() async {
    final data = await _localFile(fileName: 'account.json');
    final dataString = await data.readAsString();
    final content = jsonDecode(dataString);
    return DUTAccount.fromJson(content);
  }
}
