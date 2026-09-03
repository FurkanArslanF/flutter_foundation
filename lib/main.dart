import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_theme.dart';
import 'package:flutter_app_foundation/core/init/app_initializer.dart';
import 'package:flutter_app_foundation/core/logging/global_exception_handler.dart';
import 'package:flutter_app_foundation/core/router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  GlobalExceptionHandler.runWithGuardedZoneAsync(
    () async {
      await AppInitializer.initialize();
      return EasyLocalization(
        supportedLocales: const [Locale('tr'), Locale('en'), Locale('ar')],
        path: 'assets/lang',
        fallbackLocale: const Locale('tr'),
        startLocale: const Locale('tr'),
        useOnlyLangCode: true,
        child: const ProviderScope(child: MyApp()),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'flutter_app_foundation Mobile',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: RouterManager.instance.router,
            theme: appTheme(context),
            darkTheme: appDarkTheme(context),
            themeMode: ThemeMode.dark, // Change this to ThemeMode.dark to enable dark mode
          );
        },
      ),
    );
  }
}
