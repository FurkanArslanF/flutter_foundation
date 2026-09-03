import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  AppConstants._();

  static const String title = 'AeroMRO';

  // Pagination
  static const int defaultPageSize = 20;
  static const int firstPageKey = 1;

  // Culture codes
  static const int cultureTurkish = 1;
  static const int cultureEnglish = 2;

  // Language codes
  static const String languageTr = 'tr';
  static const String languageEn = 'en';

  // Date formats
  static const String shortDateFormat = 'dd.MM.yyyy';
  static const String longDateTimeFormat = 'dd.MM.yyyy HH:mm:ss';
  static const String mediumDateTimeFormat = 'dd.MM.yyyy HH:mm';
  static const String timeFormat = 'HH:mm:ss';
  static const String shortTimeFormat = 'HH:mm';

  // Secure storage keys
  static const String sessionIdKey = 'sessionId';
  static const String languageKey = 'language';
  static const String userIdKey = 'userId';
  static const String userNameKey = 'userName';
  static const String tokenKey = 'token';

  // File types
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];
  static const List<String> allowedVideoTypes = ['mp4', 'avi', 'mov', 'wmv'];

  // File size limits (in bytes)
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxDocumentSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 50 * 1024 * 1024; // 50MB

  // API timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Debounce duration
  static const Duration debounceDuration = Duration(milliseconds: 500);

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // Filter defaults
  static const String defaultAktifValue = 'true';
  static const String defaultOnayli = 'False';
  static const String defaultMobilMi = 'true';

  // Error messages (fallback)
  static const String defaultErrorMessage = 'Bir hata oluştu';
  static const String networkErrorMessage = 'İnternet bağlantısı yok';
  static const String timeoutErrorMessage = 'İşlem zaman aşımına uğradı';
  static const String unauthorizedMessage = 'Oturumunuz sonlanmış. Lütfen tekrar giriş yapın';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;

  // UI
  static const double defaultBorderRadius = 8;
  static const double smallBorderRadius = 4;
  static const double largeBorderRadius = 12;
  static const double defaultPadding = 16;
  static const double smallPadding = 8;
  static const double largePadding = 24;
  static const double defaultElevation = 10;
  static const double smallElevation = 5;
  static const double largeElevation = 15;
  static const double defaultSpacing = 4;
  static const double smallSpacing = 2;
  static const double largeSpacing = 8;

  // Device type checks
  static double get width => ScreenUtil().screenWidth;
  static double get height => ScreenUtil().screenHeight;

  static bool get isMobile => width < 600;
  static bool get isTablet => width >= 600 && width < 1024;
  static bool get isDesktop => width >= 1024;

  static bool get isPortrait => height > width;
  static bool get isLandscape => width > height;

  static double isMobileAndTabletLandscapeDimensions(double mobilValue, double tabletValue, double landscapeValue, {double? portraitValue}) {
    return isMobile
        ? mobilValue
        : isTablet
        ? tabletValue
        : isLandscape
        ? landscapeValue
        : isPortrait
        ? portraitValue ?? tabletValue
        : 0;
  }

  static double isMobileAndTabletLandscapeTextSize(double mobilValue, double tabletValue, double landscapeValue) {
    return isMobile
        ? mobilValue
        : isTablet
        ? tabletValue
        : isLandscape
        ? landscapeValue
        : isPortrait
        ? tabletValue
        : 0;
  }

  // Secure storage keys
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
}
