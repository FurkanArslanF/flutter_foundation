import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_app_foundation/core/widget/loading/loading.dart';
import 'package:flutter_app_foundation/features/startup/mixin/startup_view_mixin.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartupView extends ConsumerStatefulWidget {
  const StartupView({super.key});

  @override
  ConsumerState<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends ConsumerState<StartupView> with StartupViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(width: AppConstants.width, height: AppConstants.height, child: const FlutterLogo()),
          appScreenLoading(),
        ],
      ),
    );
  }
}
