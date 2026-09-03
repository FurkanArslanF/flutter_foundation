import 'package:flutter/foundation.dart';
import 'package:flutter_app_foundation/core/logging/log_level.dart';
import 'package:flutter_app_foundation/core/logging/log_model.dart';
import 'package:flutter_app_foundation/core/logging/log_sender.dart';

class LogService {
  static bool _enableConsole = true;
  static bool _enableRemote = false;
  static String? _endpoint;
  static String _environment = "development";

  static Future<void> init({
    bool enableConsole = true,
    bool enableRemote = false,
    String? endpoint,
    String environment = "development",
  }) async {
    _enableConsole = enableConsole;
    _enableRemote = enableRemote;
    _endpoint = endpoint;
    _environment = environment;
  }

  static void log(
    LogLevel level,
    String message, {
    dynamic exception,
    StackTrace? stackTrace,
  }) {
    final log = LogModel(
      level: level,
      message: message,
      environment: _environment,
      timestamp: DateTime.now(),
      exception: exception?.toString(),
      stackTrace: stackTrace?.toString(),
    );

    if (_enableConsole && kDebugMode) {
      debugPrint("🔹 [${log.level.name.toUpperCase()}] ${log.message}");
      if (log.exception != null) debugPrint("   ❗ Exception: ${log.exception}");
      if (log.stackTrace != null) {
        debugPrint("   🧩 StackTrace: ${log.stackTrace}");
      }
    }

    if (_enableRemote && _endpoint != null && kDebugMode == false) {
      LogSender.send(_endpoint!, log);
    }
  }

  static void debug(String msg) => log(LogLevel.debug, msg);
  static void info(String msg, {StackTrace? stackTrace}) => log(LogLevel.info, msg, stackTrace: stackTrace);
  static void warning(String msg, {StackTrace? stackTrace}) => log(LogLevel.warning, msg, stackTrace: stackTrace);
  static void error(String msg, {dynamic exception, StackTrace? stackTrace}) => log(LogLevel.error, msg, exception: exception, stackTrace: stackTrace);
  static void fatal(String msg, {dynamic exception, StackTrace? stackTrace}) => log(LogLevel.fatal, msg, exception: exception, stackTrace: stackTrace);
}
