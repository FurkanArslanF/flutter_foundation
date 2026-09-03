import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void appLoading(BuildContext context, bool isLoading, {bool download = false}) {
  if (isLoading) {
    unawaited(
      showDialog(
        context: context,
        // ignore: avoid_redundant_argument_values
        barrierDismissible: kDebugMode ? true : false,
        builder: (dialogContext) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: download ? Colors.green : Colors.blue,
              ),
            ],
          );
        },
      ),
    );
  }
  if (!isLoading) {
    Navigator.of(context).pop();
  }
}

Widget appScreenLoading({double height = 100, double width = 100, Color? color, double? gifSize}) {
  return Container(
    height: height.h,
    width: width.w,
    margin: EdgeInsets.only(bottom: 50.h),
    child: Center(
      child: CircularProgressIndicator(
        color: color ?? Colors.blue,
      ),
    ),
  );
}
