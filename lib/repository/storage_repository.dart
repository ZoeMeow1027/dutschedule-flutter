import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../global_variables.dart';

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
      return await getApplicationSupportDirectory();
    }
  }

  static Future<File> _localFile({String? extDir, required String fileName}) async {
    var dir = await _localDirectory(extDir: extDir);
    return File([dir.path, fileName].join(Platform.pathSeparator));
  }

  static Future<void> saveAccountSession({required Map<String, dynamic> accountSession}) async {
    final data = await _localFile(fileName: GlobalVariables.appPathFileAccountSession);
    await data.writeAsString(json.encode(accountSession));
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
    final data = await _localFile(fileName: GlobalVariables.appPathFileSettings);
    final data1 = json.encode(settings);
    await data.writeAsString(data1, mode: FileMode.writeOnly, flush: true);
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
    final data = await _localFile(fileName: GlobalVariables.appPathFileNewsSearchHistory);
    final data1 = json.encode(searchHistory);
    await data.writeAsString(data1, mode: FileMode.writeOnly, flush: true);
  }
}
