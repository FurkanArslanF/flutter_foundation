import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kartal/kartal.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.maxLines,
    this.height = 35,
    this.width = 300,
    this.enabled,
    this.inputFormatters,
    this.textInputType,
    this.labelText,
    this.labelStyle,
    this.mainStyle,
    this.onTap,
    this.onChanged,
    this.outlineInputBorder,
    this.textInputAction,
    this.color,
  });
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final int? maxLines;
  final double? height;
  final double? width;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? mainStyle;
  final void Function()? onTap;
  final void Function(String?)? onChanged;
  final OutlineInputBorder? outlineInputBorder;
  final TextInputAction? textInputAction;
  final Color? color;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    final border =
        widget.outlineInputBorder ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.BORDERCOLOR),
        );

    return Column(
      spacing: AppConstants.isMobile ? AppConstants.largeSpacing.w : AppConstants.smallSpacing.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText ?? '',
            style:
                widget.labelStyle ??
                context.general.textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE,
                ),
          ),
        SizedBox(
          height: AppConstants.isMobileAndTabletLandscapeDimensions(40.h, 30.h, 35.h),
          width: AppConstants.isMobileAndTabletLandscapeDimensions(300.w, 200.w, 250.w),
          child: TextFormField(
            scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20.h),
            controller: widget.controller,
            keyboardType: widget.textInputType ?? TextInputType.text,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled ?? true,
            obscureText: widget.obscureText ? !isObscure : false,
            maxLines: widget.maxLines ?? 1,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            cursorColor: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE,
            textInputAction: widget.textInputAction,
            style: context.general.textTheme.labelMedium?.copyWith(color: widget.color ?? (Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE)),
            decoration: InputDecoration(
              hintText: widget.hintText ?? '',
              hintStyle: context.general.textTheme.labelMedium?.copyWith(color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK.withValues(alpha: 0.6) : AppColors.WHITE.withValues(alpha: 0.6)),
              contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: AppConstants.isMobileAndTabletLandscapeDimensions(5.h, 8.h, 12.h)),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      padding: AppConstants.isMobile ? null : context.padding.onlyRightLow,
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: Icon(
                        size: AppConstants.isMobileAndTabletLandscapeDimensions(20.w, 10.w, 7.5.w),
                        isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE,
                      ),
                    )
                  : null,
              border: border,
              enabledBorder: border,
              focusedBorder: border,
              errorBorder: border,
              focusedErrorBorder: border,
              disabledBorder: border,
            ),
          ),
        ),
      ],
    );
  }
}
