import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.BGCOLOR,
    colorScheme: const ColorScheme.light(
      primary: AppColors.DARKBLUE,
      onPrimary: AppColors.WHITE,
      surface: AppColors.WHITE,
      onSurface: AppColors.BLACK,
      outline: AppColors.BORDER,
      error: AppColors.ERROR,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    buttonTheme: const ButtonThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.WHITE.withValues(alpha: 0.5),
      selectionHandleColor: AppColors.WHITE,
      cursorColor: AppColors.WHITE,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      color: AppColors.WHITE,
      shadowColor: AppColors.WHITE,
      surfaceTintColor: AppColors.WHITE,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        side: BorderSide(color: AppColors.BORDERCOLOR, width: 2),
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.WHITE,
      surfaceTintColor: AppColors.WHITE,
      elevation: 2,
      toolbarHeight: AppConstants.isMobileAndTabletLandscapeDimensions(35.h, 35.h, 45.h),
      shape: const Border(
        bottom: BorderSide(color: AppColors.BORDERCOLOR),
      ),
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: AppColors.WHITE,
      hourMinuteColor: AppColors.DARKBLUE,
      dialBackgroundColor: AppColors.WHITE,
      dialHandColor: AppColors.DARKBLUE,
      hourMinuteTextColor: AppColors.WHITE,
      dayPeriodTextColor: AppColors.WHITE,
      entryModeIconColor: AppColors.DARKBLUE,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(19.sp, 9.sp, 6.8.sp), fontWeight: FontWeight.w400),
      displayMedium: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(19.sp, 9.sp, 6.8.sp), fontWeight: FontWeight.w500),
      displaySmall: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(19.sp, 9.sp, 6.8.sp), fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(17.sp, 8.sp, 6.sp), fontWeight: FontWeight.w400),
      headlineMedium: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(17.sp, 8.sp, 6.sp), fontWeight: FontWeight.w500),
      headlineSmall: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(17.sp, 8.sp, 6.sp), fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(15.sp, 7.sp, 5.2.sp), fontWeight: FontWeight.w400),
      titleMedium: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(15.sp, 7.sp, 5.2.sp), fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(15.sp, 7.sp, 5.2.sp), fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(12.5.sp, 6.sp, 4.5.sp), fontWeight: FontWeight.w400),
      labelMedium: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(12.5.sp, 6.sp, 4.5.sp), fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(12.5.sp, 6.sp, 4.5.sp), fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(10.sp, 5.sp, 3.5.sp), fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(10.sp, 5.sp, 3.5.sp), fontWeight: FontWeight.w500),
      bodySmall: GoogleFonts.montserrat(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(10.sp, 5.sp, 3.5.sp), fontWeight: FontWeight.w600),
    ),
  );
}

ThemeData appDarkTheme(BuildContext context) {
  return appTheme(context).copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.DARK_BACKGROUND,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.PRIMARY_LIGHT,
      onPrimary: AppColors.DARK_BACKGROUND,
      surface: AppColors.DARK_SURFACE,
      onSurface: AppColors.DARK_TEXT,
      outline: AppColors.DARK_BORDER,
      error: AppColors.RED,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      color: AppColors.DARK_SURFACE,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        side: BorderSide(color: AppColors.DARK_BORDER),
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.DARK_BACKGROUND,
      surfaceTintColor: AppColors.DARK_BACKGROUND,
      elevation: 2,
      toolbarHeight: AppConstants.isMobileAndTabletLandscapeDimensions(35.h, 35.h, 45.h),
      shape: const Border(
        bottom: BorderSide(color: AppColors.DARK_BORDER),
      ),
    ),
    textTheme: appTheme(context).textTheme.apply(
      bodyColor: AppColors.DARK_TEXT,
      displayColor: AppColors.DARK_TEXT,
      decorationColor: AppColors.DARK_TEXT,
    ),
  );
}
