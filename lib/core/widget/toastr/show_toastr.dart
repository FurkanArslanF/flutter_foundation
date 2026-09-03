import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:flutter_app_foundation/core/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kartal/kartal.dart';

class _ToastrMsg {
  _ToastrMsg._();
  static final instance = _ToastrMsg._();
  bool isErrorCode = false;
  FToast? _fToast;

  @protected
  void _toastMsg(BuildContext context, String message, {bool isError = false, String? errorCode}) {
    // Context'in mounted olup olmadığını kontrol et
    if (!context.mounted) return;

    // Önceki toast'ları temizle
    _fToast?.removeQueuedCustomToasts();

    // Yeni FToast instance'ı oluştur veya yeniden kullan
    _fToast ??= FToast();
    _fToast!.init(context);

    _fToast!.showToast(
      isDismissible: true,
      positionedToastBuilder: (context, child, gravity) {
        return Positioned(top: 40.h, left: 10.w, right: 10.w, child: child);
      },
      child: Padding(
        padding: context.padding.onlyBottomNormal,
        child: SizedBox(
          width: AppConstants.isMobileAndTabletLandscapeDimensions(300.w, 175.w, 130.w),
          child: Card(
            color: AppColors.WHITE,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: context.padding.normal,
              child: Row(
                children: [
                  Icon(
                    isError ? Icons.error_outline : Icons.check_circle,
                    color: isError ? AppColors.ERROR : AppColors.SUCCESS,
                    size: AppConstants.isMobileAndTabletLandscapeDimensions(26.w, 18.w, 14.w),
                  ),
                  context.sized.emptySizedWidthBoxLow3x,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isError ? "failed".tr() : "success".tr(),
                        style: context.general.textTheme.titleSmall?.copyWith(color: AppColors.BLACK),
                      ),
                      SizedBox(
                        width: AppConstants.isMobileAndTabletLandscapeDimensions(220.w, 100.w, 90.w),
                        child: Text(
                          (isErrorCode == true && isError == true) ? "mesaj : $message code : $errorCode" : message,
                          style: context.general.textTheme.labelMedium?.copyWith(color: AppColors.BLACK),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      toastDuration: const Duration(seconds: 3),
    );
  }
}

class Toastr {
  static void showSuccess(String message, BuildContext context) {
    if (!context.mounted) return;
    _ToastrMsg.instance._toastMsg(context, message);
  }

  static void showError(String message, BuildContext context, {String? errorCode}) {
    if (!context.mounted) return;
    _ToastrMsg.instance._toastMsg(context, message, isError: true, errorCode: errorCode);
  }
}
