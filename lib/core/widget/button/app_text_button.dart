import 'package:flutter/material.dart';
import 'package:flutter_app_foundation/core/constants/app_colors.dart';
import 'package:kartal/kartal.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({super.key, required this.text, this.onPressed, this.style, this.padding, this.shape});
  final String text;
  final void Function()? onPressed;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: padding ?? EdgeInsets.zero,
        shape: shape,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: style ?? context.general.textTheme.bodySmall?.copyWith(color: AppColors.WHITE, decorationColor: AppColors.WHITE),
      ),
    );
  }
}
