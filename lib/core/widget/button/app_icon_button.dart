import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kartal/kartal.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key, this.icon, this.text, this.onPressed, this.style, this.padding, this.iconSize, this.color, this.borderRadius, this.width, this.height});
  final Widget? icon;
  final String? text;
  final void Function()? onPressed;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final Color? color;
  final double? borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w,
      height: height?.h,
      child: IconButton(
        iconSize: iconSize,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(color ?? AppColors.TRANSPARENT),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(padding ?? EdgeInsets.zero),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 30))),
        ),
        icon: Column(
          spacing: 1.h,
          children: [
            ?icon,
            if (text.ext.isNotNullOrNoEmpty) Text(text ?? "", style: style),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
