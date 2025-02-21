import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedSliverList extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final bool animate;
  final Duration? staggerDuration;
  final Duration? animationDuration;
  final bool shouldAnimateItems;

  const AnimatedSliverList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.animate = true,
    this.staggerDuration,
    this.animationDuration,
    this.shouldAnimateItems = false,
  });

  @override
  State<AnimatedSliverList> createState() => _AnimatedSliverListState();
}

class _AnimatedSliverListState extends State<AnimatedSliverList> {
  final List<int> _animatedIndices = [];
  int _previousItemCount = 0;

  @override
  void initState() {
    super.initState();
    _previousItemCount = widget.itemCount;
  }

  @override
  void didUpdateWidget(AnimatedSliverList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If new items were added and animation is enabled
    if (widget.itemCount > _previousItemCount && widget.shouldAnimateItems) {
      // Add new indices to be animated
      _animatedIndices.addAll(
        List.generate(
          widget.itemCount - _previousItemCount,
          (index) => _previousItemCount + index,
        ),
      );
    }
    _previousItemCount = widget.itemCount;
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final child = widget.itemBuilder(context, index);

          // If this index should be animated
          if (widget.animate &&
              widget.shouldAnimateItems &&
              _animatedIndices.contains(index)) {
            return child
                .animate(
                  delay: (widget.staggerDuration ?? 50.ms) * index,
                  onComplete: (controller) {
                    // Remove from animated indices once animation is complete
                    setState(() {
                      _animatedIndices.remove(index);
                    });
                  },
                )
                .fadeIn(
                  duration: widget.animationDuration ?? 400.ms,
                )
                .slideY(
                  begin: 0.2,
                  duration: widget.animationDuration ?? 400.ms,
                  curve: Curves.easeOutQuad,
                );
          }

          return child;
        },
        childCount: widget.itemCount,
      ),
    );
  }
}
