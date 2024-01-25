import 'package:flutter/foundation.dart';

class AppPrint {
  static debugPrint(String message, {StackTrace? stackTrace}) {
    if (kDebugMode) {
      print("$message ${stackTrace ?? ""}");
    }
  }
}
