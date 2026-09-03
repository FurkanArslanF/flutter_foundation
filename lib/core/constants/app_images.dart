import 'package:flutter_app_foundation/core/constants/app_constants.dart';

class AppImages {
  AppImages._();
  static final instance = AppImages._();
  static const String startupBgMobile = "assets/mobile/mobile_bg.png";
  static const String loginBgMobile = "assets/mobile/mobile_login.png";
  static const String startupBgTabletYatay = "assets/tablet/tablet_bg_yatay.png";
  static const String startupBgTabletDikey = "assets/tablet/tablet_bg_dikey.png";

  static const String loadingGif = "assets/loading/loading.gif";

  static String get startupBgImage => AppConstants.isMobile
      ? AppImages.startupBgMobile
      : AppConstants.isPortrait
      ? AppImages.startupBgTabletDikey
      : AppImages.startupBgTabletYatay;

  static String get loginBgImage => AppConstants.isMobile
      ? AppImages.loginBgMobile
      : AppConstants.isPortrait
      ? AppImages.startupBgTabletDikey
      : AppImages.startupBgTabletYatay;
}
