import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class AppUpgrader extends StatelessWidget {
  const AppUpgrader({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      showLater: false,
      showIgnore: false,
      dialogStyle: Platform.isAndroid ? UpgradeDialogStyle.material : UpgradeDialogStyle.cupertino,
      upgrader: Upgrader(
        debugLogging: kDebugMode,
        durationUntilAlertAgain: Duration.zero, // Her seferinde güncelleme göster
      ),
      cupertinoButtonTextStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 16,
      ),
      child: child,
    );
  }
}
