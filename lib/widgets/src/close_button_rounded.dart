import 'package:flutter/material.dart';
import 'package:flutter_utils/extensions/extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class CloseButtonRounded extends StatelessWidget{
  final Color? bgColor;

  const CloseButtonRounded({Key? key,this.bgColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    return InkWell(
      onTap: context.pop,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: bgColor ?? (isDarkMode ? Colors.blueGrey.withOpacity(.5) : Colors.blueGrey.withOpacity(.3)),
        child: Icon(
          Ionicons.close,
          color: isDarkMode ? Colors.grey : Colors.grey.shade700,
        ),
      ),
    );
  }
}