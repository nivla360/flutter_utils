import 'package:flutter/material.dart';
import 'package:flutter_utils/extensions/extensions.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final BoxShadow? shadow;
  final double borderRadius;
  final VoidCallback? onTap;

  const CustomCard({required this.child, this.borderRadius = 15, this.onTap,this.shadow, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            shadow ?? BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 15,
              color: context.isDarkMode
                  ? Colors.black.withOpacity(.35)
                  : Colors.blueGrey.withOpacity(.2),
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        child: Material(child: InkWell(onTap: onTap,child: child,),).clipAllCorners(borderRadius));
  }
}
