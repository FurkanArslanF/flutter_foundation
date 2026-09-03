import 'package:flutter_app_foundation/core/logging/log_level.dart';

class LogModel {
  final LogLevel level;
  final String message;
  final String environment;
  final DateTime timestamp;
  final String? exception;
  final String? stackTrace;

  LogModel({
    required this.level,
    required this.message,
    required this.environment,
    required this.timestamp,
    this.exception,
    this.stackTrace,
  });

  Map<String, dynamic> toJson() => {
    'level': level.name,
    'message': message,
    'environment': environment,
    'timestamp': timestamp.toIso8601String(),
    'exception': exception,
    'stackTrace': stackTrace,
  };
}
