import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kartal/kartal.dart';

class AppLoginButton extends StatelessWidget {
  const AppLoginButton({
    super.key,
    this.onPressed,
    this.text,
    this.style,
    this.color,
    this.width = 300,
    this.height = 35,
    this.borderRadius,
    this.leftImage,
  });

  final void Function()? onPressed;
  final String? text;
  final TextStyle? style;
  final Color? color;
  final double width;
  final double height;
  final double? borderRadius;
  final Widget? leftImage;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? AppConstants.defaultBorderRadius);

    return SizedBox(
      width: width.w,
      height: AppConstants.isMobileAndTabletLandscapeDimensions(30.h, 25.h, 35.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.LOGIN_BUTTON_COLOR, AppColors.AMBER],
          ),
          borderRadius: radius,
          border: Border.all(
            color: color ?? AppColors.WHITE,
            width: 1.w,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: leftImage != null
                ? Padding(
                    padding: const EdgeInsets.all(AppConstants.smallPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        leftImage!,
                        const SizedBox(width: 8),
                        Text(
                          text ?? '',
                          style:
                              style ??
                              context.general.textTheme.labelSmall?.copyWith(
                                color: AppColors.WHITE,
                              ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      text ?? '',
                      style:
                          style ??
                          context.general.textTheme.labelSmall?.copyWith(
                            color: AppColors.WHITE,
                          ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
