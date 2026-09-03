import 'package:easy_localization/easy_localization.dart';
import 'package:flagkit/flagkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_app_foundation/core/widget/button/app_icon_button.dart';
import 'package:flutter_app_foundation/core/widget/dropdown/searchable_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kartal/kartal.dart';

class CustomSearchDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String? initialValue;
  final String hint;
  final void Function(T?) onChanged;
  final String Function(T) displayText;
  final String? errorText;
  final bool enabled;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? menuStyle;
  final TextEditingController controller;
  final String Function(T)? phoneCode;
  final void Function(String)? onDebouncer;
  final TextInputType? keyboardType;
  final bool textMode;
  final double width;
  final double height;
  final bool showBorder;
  final void Function()? onTap;
  final bool openDropdownOnTap;

  const CustomSearchDropdown({
    super.key,
    required this.items,
    this.initialValue,
    required this.onChanged,
    required this.displayText,
    this.enabled = true,
    this.hint = 'common.select',
    this.errorText,
    this.labelText,
    this.labelStyle,
    this.menuStyle,
    required this.controller,
    this.phoneCode,
    this.onDebouncer,
    this.keyboardType,
    this.textMode = true,
    this.width = 300,
    this.height = 35,
    this.showBorder = true,
    this.onTap,
    this.openDropdownOnTap = true,
  });

  @override
  State<CustomSearchDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomSearchDropdown<T>> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style:
                widget.labelStyle ??
                context.general.textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE,
                ),
          ),
          SizedBox(height: 1.h),
        ],
        Container(
          height: AppConstants.isMobileAndTabletLandscapeDimensions(40.h, 30.h, 40.h),
          width: AppConstants.isMobileAndTabletLandscapeDimensions(300.w, 200.w, 250.w),
          decoration: widget.showBorder
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  border: Border.all(color: AppColors.BORDERCOLOR),
                )
              : null,
          child: DropDownSearchField(
            onTap: () {
              widget.onTap?.call();
            },
            textMode: widget.textMode,
            keyboardType: widget.keyboardType,
            openDropdownOnTap: widget.openDropdownOnTap,
            textFormscrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20.h),
            controller: widget.controller,
            items: widget.items.map((e) => widget.displayText(e)).toList(),
            itemBuilder: (context, item) {
              if (widget.phoneCode == null) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    item,
                    style: widget.menuStyle ??
                        context.general.textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.light ? AppColors.WHITE : AppColors.BLACK,
                        ),
                  ),
                );
              } else {
                final originalItem = widget.items.firstWhere((element) => widget.displayText(element) == item);
                final phoneCode = widget.phoneCode!(originalItem);
                return ListTile(
                  title: Row(
                    spacing: 1.h,
                    children: [
                      Flag(phoneCode),
                      Flexible(child: Text(item)),
                    ],
                  ),
                  titleTextStyle:
                      widget.menuStyle ??
                      context.general.textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.light ? AppColors.WHITE : AppColors.BLACK,
                      ),
                );
              }
            },
            onSelected: (p0) {
              setState(() {
                final selected = widget.items.firstWhere((element) => widget.displayText(element) == p0);
                widget.onChanged(selected);
              });
            },
            onChanged: (widget.onDebouncer != null)
                ? (value) {
                    widget.onDebouncer?.call(value);
                  }
                : null,
            menuDecoration: BoxDecoration(
              color: AppColors.WHITE,
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.5), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 1))],
            ),
            textFormFieldDecoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: widget.controller.text.ext.isNullOrEmpty
                  ? Padding(
                      //padding: EdgeInsets.zero,
                      padding: AppConstants.isMobile ? EdgeInsets.only(top: 7.h) : EdgeInsets.only(top: 5.h),
                      child: Icon(Icons.keyboard_arrow_down_outlined, size: AppConstants.isMobileAndTabletLandscapeDimensions(25.w, 15.w, 10.w)),
                    )
                  : AppIconButton(
                      padding: AppConstants.isMobile ? EdgeInsets.only(top: 11.h) : EdgeInsets.only(top: 8.h),
                      iconSize: AppConstants.isMobileAndTabletLandscapeDimensions(18.w, 10.w, 6.w),
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          widget.onChanged(null);
                        });
                      },
                    ),
              contentPadding: AppConstants.isMobile
                  ? EdgeInsetsDirectional.only(
                      start: context.padding.onlyLeftLow.left,
                      top: context.padding.onlyTopLow.top * 1.5,
                    )
                  : EdgeInsetsDirectional.only(
                      start: context.padding.onlyLeftLow.left,
                      top: context.padding.onlyTopLow.top,
                    ),
              hintText: widget.hint.tr(),
              hintStyle: context.general.textTheme.labelMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK.withValues(alpha: 0.6) : AppColors.WHITE.withValues(alpha: 0.6),
              ),
            ),
            textFormFieldstyle: context.general.textTheme.labelMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.light ? AppColors.BLACK : AppColors.WHITE,
            ),
            enabled: widget.enabled,
            errorWidget: widget.errorText != null
                ? Padding(
                    padding: context.padding.onlyTopLow,
                    child: Text(widget.errorText!, style: context.general.textTheme.labelMedium?.copyWith(color: AppColors.ERROR)),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
