
import 'package:flutter/material.dart';

import '../../app_flavor/app_flavor.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  const FlavorBanner({required this.child,super.key});

  @override
  Widget build(BuildContext context) {
    final instance = AppFlavor.instance;
    return instance.isProduction ? child : Banner(
      color: instance.isDev ? Colors.red : Colors.green,
      message: instance.isDev ? 'DEV' : 'STAGING',
      location: BannerLocation.topStart,
      child: child,
    );
  }
}
