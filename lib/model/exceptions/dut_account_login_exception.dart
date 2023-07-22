import 'package:dutwrapper/model/enums.dart';

class DUTAccountLoginException implements Exception {
  final String? message;
  final RequestCode requestCode;

  DUTAccountLoginException({
    this.message,
    required this.requestCode,
  });
}
