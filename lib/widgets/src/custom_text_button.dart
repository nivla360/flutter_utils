import 'package:flutter/material.dart';
import 'package:flutter_utils/extensions/extensions.dart';

import '../../util/util.dart';

enum _ButtonType { primary, secondary, tertiary }

class CustomTextButton extends StatelessWidget {
  final _ButtonType _buttonType;
  final String label;
  final Color? color;
  final IconData? icon;
  final VoidCallback? onTap;

  const CustomTextButton(
      {required this.onTap,
      this.color,
      required this.label,
      this.icon,
      Key? key})
      : _buttonType = _ButtonType.primary,
        super(key: key);

  const CustomTextButton.secondary(
      {required this.onTap,
      this.color,
      required this.label,
      this.icon,
      Key? key})
      : _buttonType = _ButtonType.secondary,
        super(key: key);

  const CustomTextButton.tertiary(
      {required this.onTap,
      this.color,
      this.icon,
      required this.label,
      Key? key})
      : _buttonType = _ButtonType.tertiary,
        super(key: key);

  @override
  Widget build(BuildContext context) {

    final isSecondary = _buttonType == _ButtonType.secondary;
    final isTertiary = _buttonType == _ButtonType.tertiary;
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
        padding: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusFifteen,
        ),
        side: isSecondary
            ? BorderSide(color: color ?? context.theme.primaryColor, width: 1.5)
            : null);
    if (icon != null) {
      return SizedBox(
        width: double.infinity,
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
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: buttonStyle,
        child: Text(
          label,
          style: textStyle,
        ),
      ),
    );
  }
}
