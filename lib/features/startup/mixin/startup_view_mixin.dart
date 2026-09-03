import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/router/go_router.dart';
import 'package:flutter_app_foundation/features/startup/view/startup_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin StartupViewMixin on ConsumerState<StartupView> {
  @override
  void initState() {
    super.initState();
    redirectToHomeNoAuthView(context);
  }

  void redirectToHomeNoAuthView(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      if (context.mounted) context.go(RouterManager.home);
    });
  }
}
