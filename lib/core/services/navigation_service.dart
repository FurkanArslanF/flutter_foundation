import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/router/go_router.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  static NavigationService get instance => _instance;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateToLogin(String message) {
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      context.go(RouterManager.root, extra: message);
    }
  }

  void navigateToError(String message) {
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      context.go(RouterManager.error, extra: message);
    }
  }

  BuildContext? get currentContext => navigatorKey.currentContext;
}
