import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/services/navigation_service.dart';
import 'package:flutter_app_foundation/error.dart';
import 'package:flutter_app_foundation/features/home/presentation/view/home.dart';
import 'package:flutter_app_foundation/features/startup/view/startup_view.dart';
import 'package:go_router/go_router.dart';

class RouterManager {
  RouterManager._();

  static const root = '/';
  static const error = '/error';
  static const home = '/home';

  // static Map<String, dynamic> _extraAsMap(GoRouterState state) {
  //   final extra = state.extra;
  //   if (extra is Map) {
  //     return extra.map((key, value) => MapEntry(key.toString(), value));
  //   }
  //   return const <String, dynamic>{};
  // }

  static Widget _splashRoute(BuildContext context, GoRouterState state) => const StartupView();
  static Widget _errorRRoute(BuildContext context, GoRouterState state) => ErrorView(message: state.extra as String?);
  static Widget _homeRoute(BuildContext context, GoRouterState state) => const HomeView();

  final GoRouter _router = GoRouter(
    navigatorKey: NavigationService.instance.navigatorKey,
    debugLogDiagnostics: kReleaseMode ? false : true,
    //errorBuilder: _errorRoute,
    routes: <RouteBase>[
      GoRoute(path: root, builder: _splashRoute),
      GoRoute(path: error, builder: _errorRRoute),
      GoRoute(path: home, builder: _homeRoute),
    ],
  );

  static final RouterManager _instance = RouterManager._();
  static RouterManager get instance => _instance;

  GoRouter get router => _router;
}
