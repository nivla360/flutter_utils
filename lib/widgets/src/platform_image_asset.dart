import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformImageAsset extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final double borderRadius;

  const PlatformImageAsset(this.source,
      {Key? key,
      this.width,
      this.height,
      this.borderRadius = 0,
      this.fit,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: kIsWeb
          ? Image.network(
              source,
              width: width,
              height: height,
              fit: fit,
              color: color,
            )
          : Image.asset(
              source,
              width: width,
              height: height,
              fit: fit,
              color: color,
            ),
    );
  }
}
