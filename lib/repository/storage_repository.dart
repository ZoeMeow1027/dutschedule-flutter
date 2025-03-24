import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dutwrapper/account_session_object.dart';
import 'package:path_provider/path_provider.dart';

class StorageRepository {
  static Future<File> _localFile({required String fileName}) async {
    if (Platform.isWindows) {
      String directory = "${Platform.environment['appdata']}\\ZoeMeow.DutSchedule";
      if (!await Directory(directory).exists()) {
        await Directory(directory).create();
      }
      log('$directory\\$fileName');
      return File('$directory\\$fileName');
    } else {
      String directory = (await getApplicationSupportDirectory()).path;
      log('$directory/$fileName');
      return File('$directory/$fileName');
    }
  }

  static Future<void> saveAccountSession({required AccountSession session}) async {
    final data = await _localFile(fileName: 'account.json');
    await data.writeAsString(jsonEncode(session.toJson()));
  }

  static Future<AccountSession> loadAccountSession() async {
    try {
      final data = await _localFile(fileName: 'account.json');
      final dataString = await data.readAsString();
      final content = jsonDecode(dataString);
      return AccountSession.fromJson(content);
    } catch (ex) {
      return AccountSession.createDefault();
    }
  }

  static Future<void> saveSettings({required Map<String, dynamic> settings}) async {
    final data = await _localFile(fileName: 'settings.json');
    final data1 = json.encode(settings);
    await data.writeAsString(data1, mode: FileMode.writeOnly, flush: true);
  }

  static Future<Map<String, dynamic>> getPreviousSettings() async {
    try {
      final data = await _localFile(fileName: 'settings.json');
      final dataString = await data.readAsString();
      return json.decode(dataString);
    } catch (ex) {
      return {};
    } finally {
    }
  }

  static Map<String, dynamic> getPreviousSettingsSync() {
    try {
      String data = "{}";
      _localFile(fileName: 'settings.json').then((onValue) {
        onValue.readAsString().then((data1) {
          data = data1;
        });
      });
      return json.decode(data);
    } catch (ex) {
      return {};
    } finally {
    }
  }
}
