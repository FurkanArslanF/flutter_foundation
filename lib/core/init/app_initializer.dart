import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/logging/log_service.dart';
import 'package:flutter_app_foundation/env.dart';

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initialLogging();
    await _initializeLocalization();
    if (kDebugMode) {
      debugPrint('BaseUrl : ${Env.baseUrl}');
      // ignore: deprecated_member_use
      debugPrint('Screen Size and Orientation: ${WidgetsBinding.instance.window.physicalSize} (${WidgetsBinding.instance.window.devicePixelRatio})');
    }
  }

  static Future<void> _initializeLocalization() async {
    EasyLocalization.logger.enableBuildModes = [];
    await EasyLocalization.ensureInitialized();
  }

  static Future<void> _initialLogging() async {
    await LogService.init(
      enableRemote: true,
      environment: kReleaseMode ? "prod" : "dev",
    );
  }
}
