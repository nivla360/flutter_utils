import 'package:flutter/material.dart';

/// A skeleton loading widget that shows a shimmer effect
/// Used to indicate loading states with a modern skeleton UI
class SkeletonLoader extends StatefulWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? duration;

  const SkeletonLoader({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
    this.baseColor,
    this.highlightColor,
    this.duration,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final baseColor = widget.baseColor ??
        (isDark ? Colors.grey[800]! : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ??
        (isDark ? Colors.grey[700]! : Colors.grey[100]!);

    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
              gradient: LinearGradient(
                colors: [
                  baseColor,
                  highlightColor,
                  baseColor,
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(-1.0 + _animation.value, 0),
                end: Alignment(1.0 + _animation.value, 0),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Predefined skeleton shapes for common use cases
class SkeletonShapes {
  /// Circular skeleton (for avatars, profile pictures)
  static Widget circle({
    required double size,
    Color? baseColor,
    Color? highlightColor,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonLoader(
      height: size,
      width: size,
      borderRadius: BorderRadius.circular(size / 2),
      baseColor: baseColor,
      highlightColor: highlightColor,
      margin: margin,
    );
  }

  /// Rectangular skeleton with rounded corners
  static Widget rectangle({
    required double height,
    required double width,
    double borderRadius = 8,
    Color? baseColor,
    Color? highlightColor,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonLoader(
      height: height,
      width: width,
      borderRadius: BorderRadius.circular(borderRadius),
      baseColor: baseColor,
      highlightColor: highlightColor,
      margin: margin,
    );
  }

  /// Text line skeleton
  static Widget textLine({
    double height = 16,
    double? width,
    Color? baseColor,
    Color? highlightColor,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonLoader(
      height: height,
      width: width,
      borderRadius: BorderRadius.circular(height / 2),
      baseColor: baseColor,
      highlightColor: highlightColor,
      margin: margin,
    );
  }

  /// Button skeleton
  static Widget button({
    double height = 48,
    double? width,
    double borderRadius = 24,
    Color? baseColor,
    Color? highlightColor,
    EdgeInsetsGeometry? margin,
  }) {
    return SkeletonLoader(
      height: height,
      width: width,
      borderRadius: BorderRadius.circular(borderRadius),
      baseColor: baseColor,
      highlightColor: highlightColor,
      margin: margin,
    );
  }
}

/// A widget that builds skeleton placeholders for lists
class SkeletonListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const SkeletonListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.itemExtent,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      padding: padding,
      itemExtent: itemExtent,
      physics: physics,
      shrinkWrap: shrinkWrap,
    );
  }
}

/// Pre-built skeleton layouts for common UI patterns
class SkeletonLayouts {
  /// List item with avatar, title, and subtitle
  static Widget listTile({
    bool showAvatar = true,
    bool showSubtitle = true,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      child: Row(
        children: [
          if (showAvatar)
            SkeletonShapes.circle(
              size: 48,
              margin: const EdgeInsets.only(right: 16),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonShapes.textLine(
                  height: 16,
                  width: double.infinity,
                ),
                if (showSubtitle) ...[
                  const SizedBox(height: 8),
                  SkeletonShapes.textLine(
                    height: 14,
                    width: 200,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card layout with image, title, and description
  static Widget card({
    double imageHeight = 200,
    bool showImage = true,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showImage)
            SkeletonShapes.rectangle(
              height: imageHeight,
              width: double.infinity,
              borderRadius: 8,
              margin: const EdgeInsets.only(bottom: 16),
            ),
          SkeletonShapes.textLine(
            height: 18,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
          ),
          SkeletonShapes.textLine(
            height: 14,
            width: 250,
            margin: const EdgeInsets.only(bottom: 4),
          ),
          SkeletonShapes.textLine(
            height: 14,
            width: 180,
          ),
        ],
      ),
    );
  }

  /// Article/blog post layout
  static Widget article({
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          SkeletonShapes.textLine(
            height: 20,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
          ),
          SkeletonShapes.textLine(
            height: 20,
            width: 280,
            margin: const EdgeInsets.only(bottom: 16),
          ),
          
          // Author info
          Row(
            children: [
              SkeletonShapes.circle(
                size: 32,
                margin: const EdgeInsets.only(right: 12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonShapes.textLine(
                      height: 14,
                      width: 100,
                      margin: const EdgeInsets.only(bottom: 4),
                    ),
                    SkeletonShapes.textLine(
                      height: 12,
                      width: 80,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Content lines
          ...List.generate(5, (index) {
            return SkeletonShapes.textLine(
              height: 14,
              width: index == 4 ? 160 : double.infinity,
              margin: const EdgeInsets.only(bottom: 6),
            );
          }),
        ],
      ),
    );
  }

  /// Profile header layout
  static Widget profile({
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile picture
          SkeletonShapes.circle(
            size: 100,
            margin: const EdgeInsets.only(bottom: 16),
          ),
          
          // Name
          SkeletonShapes.textLine(
            height: 20,
            width: 150,
            margin: const EdgeInsets.only(bottom: 8),
          ),
          
          // Bio
          SkeletonShapes.textLine(
            height: 14,
            width: 200,
            margin: const EdgeInsets.only(bottom: 4),
          ),
          SkeletonShapes.textLine(
            height: 14,
            width: 180,
            margin: const EdgeInsets.only(bottom: 16),
          ),
          
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return Column(
                children: [
                  SkeletonShapes.textLine(
                    height: 18,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 4),
                  ),
                  SkeletonShapes.textLine(
                    height: 12,
                    width: 60,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}