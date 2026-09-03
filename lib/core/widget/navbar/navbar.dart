import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavbarBottom extends StatefulWidget {
  const NavbarBottom({super.key, required this.currentIndex, this.onTap});
  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  State<NavbarBottom> createState() => _NavbarBottomState();
}

class _NavbarBottomState extends State<NavbarBottom> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.fromLTRB(AppConstants.isMobileAndTabletLandscapeDimensions(30.w, 100.w, 120.w), 0, AppConstants.isMobileAndTabletLandscapeDimensions(30.w, 100.w, 120.w), AppConstants.isMobileAndTabletLandscapeDimensions(12.h, 20.h, 30.h)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light ? AppColors.WHITE.withValues(alpha: 0.7) : AppColors.DARK_BORDER,
          borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius * 2),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.light ? AppColors.GRAY2.withValues(alpha: 0.5) : AppColors.DARK_BACKGROUND.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light ? AppColors.GRAY2.withValues(alpha: 0.22) : AppColors.DARK_BACKGROUND.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius * 2),
          child: SizedBox(
            height: AppConstants.isMobileAndTabletLandscapeDimensions(52.h, 45.h, 45.h),
            child: BottomNavigationBar(
              currentIndex: widget.currentIndex,
              onTap: widget.onTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE,
              unselectedItemColor: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK.withValues(alpha: 0.58) : AppColors.WHITE.withValues(alpha: 0.58),
              selectedIconTheme: IconThemeData(size: AppConstants.isMobileAndTabletLandscapeDimensions(20.w, 10.w, 6.w), color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE),
              unselectedIconTheme: IconThemeData(size: AppConstants.isMobileAndTabletLandscapeDimensions(20.w, 10.w, 6.w), color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK.withValues(alpha: 0.58) : AppColors.WHITE.withValues(alpha: 0.58)),
              selectedLabelStyle: TextStyle(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(10.sp, 5.sp, 4.sp), fontWeight: FontWeight.w600, color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE),
              unselectedLabelStyle: TextStyle(fontSize: AppConstants.isMobileAndTabletLandscapeTextSize(10.sp, 5.sp, 4.sp), fontWeight: FontWeight.w400, color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK.withValues(alpha: 0.58) : AppColors.WHITE.withValues(alpha: 0.58)),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: AppConstants.isMobileAndTabletLandscapeDimensions(22.w, 10.w, 7.w), color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK.withValues(alpha: 0.58) : AppColors.WHITE.withValues(alpha: 0.58)),
                  activeIcon: Icon(Icons.home, size: AppConstants.isMobileAndTabletLandscapeDimensions(22.w, 10.w, 7.w), color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined, size: AppConstants.isMobileAndTabletLandscapeDimensions(22.w, 10.w, 7.w), color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK.withValues(alpha: 0.58) : AppColors.WHITE.withValues(alpha: 0.58)),
                  activeIcon: Icon(Icons.search, size: AppConstants.isMobileAndTabletLandscapeDimensions(22.w, 10.w, 7.w), color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, size: AppConstants.isMobileAndTabletLandscapeDimensions(22.w, 10.w, 7.w), color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK.withValues(alpha: 0.58) : AppColors.WHITE.withValues(alpha: 0.58)),
                  activeIcon: Icon(Icons.person, size: AppConstants.isMobileAndTabletLandscapeDimensions(22.w, 10.w, 7.w), color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, size: AppConstants.isMobileAndTabletLandscapeDimensions(22.w, 10.w, 7.w), color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK.withValues(alpha: 0.58) : AppColors.WHITE.withValues(alpha: 0.58)),
                  activeIcon: Icon(Icons.person, size: AppConstants.isMobileAndTabletLandscapeDimensions(22.w, 10.w, 7.w), color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
