import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppElevetedButton extends StatelessWidget {
  const AppElevetedButton({super.key, this.onPressed, this.text, this.style, this.color, this.width = 300, this.height = 35, this.borderRadius, this.leftImage});
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
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.WHITE,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.defaultBorderRadius),
            side: BorderSide(color: color ?? AppColors.WHITE, width: 1.w),
          ),
        ),
        onPressed: onPressed,
        child: leftImage != null
            ? Padding(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                child: Row(
                  spacing: AppConstants.smallSpacing.w,
                  children: [
                    leftImage!,
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.smallPadding),
                      child: Text(text ?? "", style: style),
                    ),
                  ],
                ),
              )
            : Text(text ?? "", style: style),
      ),
    );
  }
}
