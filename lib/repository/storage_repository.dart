import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../global_variables.dart';
import '../model/notification_history.dart';

class StorageRepository {
  static Future<Directory> _localDirectory({String? extDir}) async {
    if (Platform.isWindows) {
      List<String?> dirSplit = [Platform.environment['appdata'], GlobalVariables.appDirRoot];
      if (dirSplit.any((p) => p == null)) {
        throw Exception("Some path is null!");
      }
      if (extDir != null) {
        dirSplit.add(extDir);
      }
      String directory = dirSplit.join(Platform.pathSeparator);

      if (!await Directory(directory).exists()) {
        await Directory(directory).create(recursive: true);
      }
      return Directory(directory);
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  static Future<File> _localFile({String? extDir, required String fileName}) async {
    var dir = await _localDirectory(extDir: extDir);
    return File([dir.path, fileName].join(Platform.pathSeparator));
  }

  static Future<void> saveAccountSession({required Map<String, dynamic> accountSession}) async {
    var jsonEncoder = JsonEncoder.withIndent('    ');
    final data = await _localFile(fileName: GlobalVariables.appPathFileAccountSession);
    await data.writeAsString(jsonEncoder.convert(accountSession));
  }

  static Future<Map<String, dynamic>> loadAccountSession() async {
    try {
      final data = await _localFile(fileName: GlobalVariables.appPathFileAccountSession);
      final dataString = await data.readAsString();
      return json.decode(dataString);
    } catch (ex) {
      return {};
    }
  }

  static Future<void> saveSettings({required Map<String, dynamic> settings}) async {
    var jsonEncoder = JsonEncoder.withIndent('    ');
    final data = await _localFile(fileName: GlobalVariables.appPathFileSettings);
    await data.writeAsString(jsonEncoder.convert(settings), mode: FileMode.writeOnly, flush: true);
  }

  static Future<Map<String, dynamic>> getPreviousSettings() async {
    try {
      final data = await _localFile(fileName: GlobalVariables.appPathFileSettings);
      final dataString = await data.readAsString();
      return json.decode(dataString);
    } catch (ex) {
      return {};
    } finally {}
  }

  static Future<void> saveNewsCache({required Map<String, dynamic> settings}) async {
    var jsonEncoder = JsonEncoder.withIndent('    ');
    final data = await _localFile(fileName: GlobalVariables.appPathNewsCache);
    await data.writeAsString(jsonEncoder.convert(settings), mode: FileMode.writeOnly, flush: true);
  }

  static Future<Map<String, dynamic>> getNewsCache() async {
    try {
      final data = await _localFile(fileName: GlobalVariables.appPathNewsCache);
      final dataString = await data.readAsString();
      return json.decode(dataString);
    } catch (ex) {
      return {};
    } finally {}
  }

  static Future<void> saveAccountCache({required Map<String, dynamic> accountCache}) async {
    var jsonEncoder = JsonEncoder.withIndent('    ');
    final data = await _localFile(fileName: GlobalVariables.appPathFileAccountCache);
    await data.writeAsString(jsonEncoder.convert(accountCache), mode: FileMode.writeOnly, flush: true);
  }

  static Future<Map<String, dynamic>> getAccountCache() async {
    try {
      final data = await _localFile(fileName: GlobalVariables.appPathFileAccountCache);
      final dataString = await data.readAsString();
      return json.decode(dataString);
    } catch (ex) {
      return {};
    } finally {}
  }

  static Future<void> saveNotificationHistory({required List<NotificationHistory> notifyHistory}) async {
    var jsonEncoder = JsonEncoder.withIndent('    ');
    final data = await _localFile(fileName: GlobalVariables.appPathNotificationHistory);
    final data1 = jsonEncoder.convert(notifyHistory.map((p) => p.toJson()).toList());
    await data.writeAsString(data1, mode: FileMode.writeOnly, flush: true);
  }

  static Future<List<NotificationHistory>> getNotificationHistory() async {
    try {
      final data = await _localFile(fileName: GlobalVariables.appPathNotificationHistory);
      final dataString = await data.readAsString();
      return (json.decode(dataString) as List<dynamic>).map((p) => NotificationHistory.fromJson(data: p)).toList();
    } catch (ex) {
      return [];
    } finally {}
  }

  static Future<Map<String, dynamic>> getNewsSearchHistory() async {
    try {
      final data = await _localFile(fileName: GlobalVariables.appPathFileNewsSearchHistory);
      final dataString = await data.readAsString();
      return json.decode(dataString);
    } catch (ex) {
      return {};
    } finally {}
  }

  static Future<void> saveNewsSearchHistory({required Map<String, dynamic> searchHistory}) async {
    var jsonEncoder = JsonEncoder.withIndent('    ');
    final data = await _localFile(fileName: GlobalVariables.appPathFileNewsSearchHistory);
    await data.writeAsString(jsonEncoder.convert(searchHistory), mode: FileMode.writeOnly, flush: true);
  }
}
