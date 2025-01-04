import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/extensions/extensions.dart';

import '../../util/util.dart';

enum _ButtonType { primary, secondary, tertiary }

class CustomTextButton extends StatelessWidget {
  final _ButtonType _buttonType;
  final String label;
  final Color? color;
  final IconData? icon;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const CustomTextButton(
      {required this.onTap,
      this.color,
      required this.label,
        this.width,
        this.padding,
        this.borderRadius,
      this.icon,
      super.key})
      : _buttonType = _ButtonType.primary;

  const CustomTextButton.secondary(
      {required this.onTap,
      this.color,
      required this.label,
        this.padding,
        this.width,
        this.borderRadius,
      this.icon,
      super.key})
      : _buttonType = _ButtonType.secondary;

  const CustomTextButton.tertiary(
      {required this.onTap,
      this.color,
      this.icon,
      required this.label,
        this.padding,
        this.width,
        this.borderRadius,
      super.key})
      : _buttonType = _ButtonType.tertiary;

  @override
  Widget build(BuildContext context) {

    final isSecondary = _buttonType == _ButtonType.secondary;
    final isTertiary = _buttonType == _ButtonType.tertiary;
    final newPadding = padding ?? (context.screenIsDesktop ? const EdgeInsets.symmetric(vertical: 22) :  const EdgeInsets.all(18));
    final textStyle = TextStyle(
        color: isSecondary
            ? (color ?? context.theme.primaryColor)
            : isTertiary
                ? Colors.white
                : (color ?? context.theme.primaryColor) == Colors.white
                    ? Colors.black
                    : Colors.white);
    final buttonStyle = TextButton.styleFrom(
        backgroundColor: isSecondary
            ? null
            : (color ??
                (isTertiary
                    ? Colors.grey.shade600
                    : context.theme.primaryColor)),
        padding: newPadding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? borderRadiusFifteen,
        ),
        side: isSecondary
            ? BorderSide(color: color ?? context.theme.primaryColor, width: 1.5)
            : null);
    if (icon != null) {
      return SizedBox(
        width: width ?? double.infinity,
        child: TextButton.icon(
            onPressed: onTap,
            icon: Icon(
              icon,
              color: !isSecondary ? Colors.white : context.theme.primaryColor,
            ),
            style: buttonStyle,
            label: Text(
              label,
              style: textStyle,
            )),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      child: onTap == null ? Opacity(opacity: 0.4, child: TextButton(
        onPressed: onTap,
        style: buttonStyle,
        child: Text(
          label,
          style: textStyle,
        ),
      )): TextButton(
        onPressed: onTap,
        style: buttonStyle,
        child: Text(
          label,
          style: textStyle,
        ),
      ) ,
    );
  }
}
