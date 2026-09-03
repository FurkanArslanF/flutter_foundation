import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kartal/kartal.dart';

class CustomSegmentedButton extends StatefulWidget {
  const CustomSegmentedButton({
    super.key,
    required this.leftText,
    required this.rightText,
    this.initialSelectedSegment = 1,
    this.onSegmentChanged,
  });

  final String leftText;
  final String rightText;
  final int initialSelectedSegment;
  final ValueChanged<int>? onSegmentChanged;

  @override
  State<CustomSegmentedButton> createState() => _CustomSegmentedButtonState();
}

class _CustomSegmentedButtonState extends State<CustomSegmentedButton> {
  late int _selectedSegment;

  @override
  void initState() {
    super.initState();
    _selectedSegment = widget.initialSelectedSegment;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.isMobileAndTabletLandscapeDimensions(30.h, 25.h, 35.h),
      decoration: BoxDecoration(
        color: AppColors.BGCOLOR.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.1),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSegment = 1;
                });
                widget.onSegmentChanged?.call(_selectedSegment);
              },
              child: AnimatedContainer(
                duration: const Duration(),
                height: AppConstants.isMobileAndTabletLandscapeDimensions(30.h, 25.h, 35.h),
                decoration: BoxDecoration(
                  gradient: _selectedSegment == 1
                      ? const LinearGradient(
                          colors: [
                            AppColors.LOGIN_BUTTON_COLOR,
                            AppColors.AMBER,
                          ],
                        )
                      : null,
                  color: _selectedSegment == 1 ? null : AppColors.TRANSPARENT,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(AppConstants.defaultBorderRadius),
                  ),
                  border: Border(
                    left: BorderSide(
                      color: AppColors.LOGIN_BUTTON_COLOR.withValues(alpha: 0.1),
                      width: 1.w,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.leftText,
                  style: context.general.textTheme.labelSmall?.copyWith(color: _selectedSegment == 1 ? AppColors.DARKBLUE : AppColors.DARKBLUE.withValues(alpha: 0.45)),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSegment = 2;
                });
                widget.onSegmentChanged?.call(_selectedSegment);
              },
              child: AnimatedContainer(
                duration: const Duration(),
                height: AppConstants.isMobileAndTabletLandscapeDimensions(30.h, 25.h, 35.h),
                decoration: BoxDecoration(
                  gradient: _selectedSegment == 2
                      ? const LinearGradient(
                          colors: [
                            AppColors.LOGIN_BUTTON_COLOR,
                            AppColors.AMBER,
                          ],
                        )
                      : null,
                  color: _selectedSegment == 2 ? null : AppColors.TRANSPARENT,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(AppConstants.defaultBorderRadius),
                  ),
                  border: Border(
                    right: BorderSide(
                      color: AppColors.LOGIN_BUTTON_COLOR.withValues(alpha: 0.1),
                      width: 1.w,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.rightText,
                  style: context.general.textTheme.labelSmall?.copyWith(color: _selectedSegment == 2 ? AppColors.DARKBLUE : AppColors.DARKBLUE.withValues(alpha: 0.45)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
