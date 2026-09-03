// ignore_for_file: inference_failure_on_untyped_parameter

import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_app_foundation/core/logging/log_service.dart';

class GlobalExceptionHandler {
  static bool _isInitialized = false;

  /// Uygulamayı global exception handling ile çalıştırır
  static void runWithGuardedZone(Widget app) {
    if (_isInitialized) {
      LogService.warning("GlobalExceptionHandler zaten başlatılmış");
      runApp(app);
      return;
    }

    _setupFlutterErrorHandling();
    _setupPlatformErrorHandling();
    _setupIsolateErrorHandling();

    runZonedGuarded(() {
      _isInitialized = true;
      runApp(app);
    }, _handleZonedError);
  }

  /// Async initialization ile uygulamayı global exception handling ile çalıştırır
  static void runWithGuardedZoneAsync(Future<Widget> Function() appBuilder) {
    if (_isInitialized) {
      LogService.warning("GlobalExceptionHandler zaten başlatılmış");
      return;
    }

    _setupFlutterErrorHandling();
    _setupPlatformErrorHandling();
    _setupIsolateErrorHandling();

    runZonedGuarded(() async {
      _isInitialized = true;
      final app = await appBuilder();
      runApp(app);
    }, _handleZonedError);
  }

  /// Flutter framework hatalarını yakalar
  static void _setupFlutterErrorHandling() {
    FlutterError.onError = (details) {
      // Debug modda hata detaylarını göster
      if (kDebugMode) {
        FlutterError.presentError(details);
      }

      final errorMessage = _buildErrorMessage("Flutter Framework Error", details.exceptionAsString(), details.context?.toString());

      LogService.error(errorMessage, exception: details.exception, stackTrace: details.stack);

      // Production modda Firebase Crashlytics'e gönder
      if (kReleaseMode) {
        //FirebaseCrashlytics.instance.recordFlutterError(details);
      }
    };
  }

  /// Platform (native) hatalarını yakalar
  static void _setupPlatformErrorHandling() {
    PlatformDispatcher.instance.onError = (error, stack) {
      final errorMessage = _buildErrorMessage("Platform Error", error.toString(), "Native platform error occurred");

      LogService.error(errorMessage, exception: error, stackTrace: stack);

      // Production modda Firebase Crashlytics'e gönder
      if (kReleaseMode) {
        //FirebaseCrashlytics.instance.recordError(error, stack, fatal: true, information: ["Platform error - app may crash"]);
      }

      return true; // Uygulamanın crash olmasını engelle
    };
  }

  /// Isolate hatalarını yakalar
  static void _setupIsolateErrorHandling() {
    Isolate.current.addErrorListener(
      RawReceivePort((pair) {
        if (pair is! List<dynamic> || pair.length < 2) {
          LogService.error("Invalid isolate error payload", exception: pair);
          return;
        }

        final errorAndStacktrace = pair;
        final error = errorAndStacktrace.first;
        final rawStackTrace = errorAndStacktrace.last;
        final stackTrace = rawStackTrace is StackTrace ? rawStackTrace : StackTrace.fromString(rawStackTrace.toString());

        final errorMessage = _buildErrorMessage("Isolate Error", error.toString(), "Error occurred in isolate");

        LogService.fatal(errorMessage, exception: error, stackTrace: stackTrace);

        // Production modda Firebase Crashlytics'e gönder
        if (kReleaseMode) {
          //await FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true, information: ["Isolate error"]);
        }
      }).sendPort,
    );
  }

  /// Zone hatalarını işler
  static void _handleZonedError(Object error, StackTrace stackTrace) {
    final errorMessage = _buildErrorMessage("Zoned Error", error.toString(), "Uncaught error in zone");

    LogService.error(errorMessage, exception: error, stackTrace: stackTrace);

    // Production modda Firebase Crashlytics'e gönder
    if (kReleaseMode) {
      //FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: false, information: ["Caught by zone guard"]);
    }

    // Debug modda kullanıcıya bilgi ver
    if (kDebugMode) {
      debugPrint("🚨 GLOBAL ERROR CAUGHT: $error");
      debugPrint("📍 STACK TRACE: $stackTrace");
    }
  }

  /// Hata mesajını formatlar
  static String _buildErrorMessage(String type, String error, String? context) {
    final buffer = StringBuffer()
      ..writeln("🚨 $type")
      ..writeln("📱 App: ${AppConstants.title}")
      ..writeln("🕐 Time: ${DateTime.now().toIso8601String()}")
      ..writeln("🐛 Error: $error");

    if (context != null && context.isNotEmpty) {
      buffer.writeln("📍 Context: $context");
    }

    buffer.writeln("🏗️ Build Mode: ${kReleaseMode ? 'Release' : 'Debug'}");

    return buffer.toString();
  }

  /// Manuel hata raporlama için
  static void reportError(String message, Object? error, StackTrace? stackTrace, {Map<String, dynamic>? additionalData}) {
    final errorMessage = _buildErrorMessage("Manual Report", message, additionalData?.toString());

    LogService.error(errorMessage, exception: error, stackTrace: stackTrace);

    if (kReleaseMode && error != null) {
      //FirebaseCrashlytics.instance.recordError(error, stackTrace ?? StackTrace.current, fatal: false, information: [message]);
    }
  }

  /// Exception handler'ın başlatılıp başlatılmadığını kontrol eder
  static bool get isInitialized => _isInitialized;
}
