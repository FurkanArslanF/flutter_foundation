import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kartal/kartal.dart';

Future<void> showPopup(BuildContext context, {required Widget child}) async {
  unawaited(
    showDialog(
      context: context,
      // ignore: avoid_redundant_argument_values
      barrierDismissible: kDebugMode ? true : false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.TRANSPARENT,
          shadowColor: AppColors.TRANSPARENT,
          surfaceTintColor: AppColors.TRANSPARENT,
          alignment: Alignment.center,
          constraints: BoxConstraints(
            maxWidth: AppConstants.isMobileAndTabletLandscapeDimensions(300.w, 165.w, 120.w),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: AppConstants.isMobileAndTabletLandscapeDimensions(20.w, 10.w, 5.w)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius)),
          child: Padding(padding: context.padding.normal, child: child),
        );
      },
    ),
  );
}
