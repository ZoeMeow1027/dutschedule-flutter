import 'package:dutwrapper/model/global_obj_var.dart';

class DUTAccountLoginException implements Exception {
  final String? message;
  final RequestCode requestCode;

  DUTAccountLoginException({
    this.message,
    required this.requestCode,
  });
}
