import 'package:flutter/foundation.dart';
import 'package:flutter_app_foundation/core/logging/log_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInstallationTracker {
  static const String _lastVersionKey = 'last_app_version_logged';

  static Future<void> logInstallType() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
      final preferences = await SharedPreferences.getInstance();
      final previousVersion = preferences.getString(_lastVersionKey);

      if (previousVersion == null || previousVersion.isEmpty) {
        LogService.info('App installation detected: fresh_install (version: $currentVersion)', stackTrace: StackTrace.fromString("AppInstallationTracker.logInstallType"));
      } else if (previousVersion != currentVersion) {
        LogService.info('App installation detected: update (from: $previousVersion to: $currentVersion)', stackTrace: StackTrace.fromString("AppInstallationTracker.logInstallType"));
      }

      if (previousVersion != currentVersion) {
        await preferences.setString(_lastVersionKey, currentVersion);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('App installation tracking failed: $e');
      }
      LogService.error('App installation tracking error', exception: e, stackTrace: stackTrace);
    }
  }
}
