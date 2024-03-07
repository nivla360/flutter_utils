import 'package:flutter/material.dart';
import 'package:flutter_utils/extensions/extensions.dart';
import './close_button_rounded.dart';


class CustomModal extends StatelessWidget {
  final String? title;
  final Widget? bottomButton;
  final EdgeInsetsGeometry padding;
  final List<Widget> actions;
  final Widget child;

  const CustomModal(
      {required this.child,
        this.title,
        this.actions = const [],
        this.padding = const EdgeInsets.all(15),
        this.bottomButton,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = Radius.circular(15);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: borderRadius, topLeft: borderRadius),
      child: Container(
        color: context.theme.scaffoldBackgroundColor,
        height: context.height * .85,
        padding: padding,
        child: (title == null && bottomButton == null)
            ? child
            : Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title ?? '',
                    style: context.theme.appBarTheme.titleTextStyle,
                  ),
                ),
                ...actions,
                const CloseButtonRounded().paddingOnly(left: 3),
              ],
            ).paddingOnly(bottom: 10),
            Expanded(child: child),
            if (bottomButton != null)
              bottomButton!.paddingOnly(top: 10)
          ],
        ),
      ),
    );
  }
}