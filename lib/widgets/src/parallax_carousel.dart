import 'dart:async';
import 'package:flutter/material.dart';


class ParallaxCarousel extends StatefulWidget {
  ///List with assets path or url. Required
  final List<Widget> items;
  ///OnTap function. Index = index of active page. Optional
  final Function(int index)? onTap, onPageChanged;
  ///Height of whole carousel. Required
  final double height;
  ///Height of nearby images. From 0.0 to 1.0. Optional
  final double scaleFactor;
  ///Border radius of image. Optional
  final double? borderRadius;
  ///Vertical alignment of nearby images. Optional
  final Alignment? verticalAlignment;
  //Enable parallax
  final bool enableParallax;
  final bool enablePadding;
  //when set to 1 makes one item show at a time but if less than 1 shows the other items by the current item
  final double viewPortFraction;
  //scroll physics
  final ScrollPhysics scrollPhysics;
  ///Auto scroll
  final bool autoScroll; //not yet implemented
  ///Auto Scroll Duration
  final Duration autoScrollInterval,
      autoScrollAnimationDuration; //not yet implemented
  const ParallaxCarousel(
      {Key? key,
        required this.items,
        required this.height,
        this.onTap,
        this.autoScroll = false,
        this.viewPortFraction = 0.9,
        this.onPageChanged,
        this.enablePadding = true,
        this.enableParallax = true,
        this.scrollPhysics = const BouncingScrollPhysics(),
        this.autoScrollInterval =
        const Duration(seconds: 4), //not yet implemented
        this.autoScrollAnimationDuration =
        const Duration(milliseconds: 800), //not yet implemented
        this.scaleFactor = 1.0,
        this.borderRadius,
        this.verticalAlignment})
      : assert(scaleFactor > 0.0),
        assert(scaleFactor <= 1.0),
        super(key: key);
  @override
  _ParallaxCarouselState createState() => _ParallaxCarouselState();
}
class _ParallaxCarouselState extends State<ParallaxCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  double _currentPageValue = 0.0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewPortFraction);
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page!;
      });
    });
    timer = getTimer();
  }
  Timer? getTimer() {
    return widget.autoScroll
        ? Timer.periodic(widget.autoScrollInterval, (_) {
      if (_pageController.page == (widget.items.length - 1).toDouble()) {
        _pageController.animateToPage(0,
            duration: widget.autoScrollAnimationDuration,
            curve: Curves.easeInExpo);
      } else {
        _pageController.nextPage(
            duration: widget.autoScrollAnimationDuration,
            curve: Curves.fastOutSlowIn);
      }
    })
        : null;
  }
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    _pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: widget.height,
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            return PageView.builder(
              // pageSnapping: true,
              physics:  widget.scrollPhysics,
              controller: _pageController,
              onPageChanged: widget.onPageChanged,
              itemCount: widget.items.length,
              itemBuilder: (context, position) {
                double value = (1 -
                    ((_currentPageValue - position).abs() *
                        (1 - widget.scaleFactor)))
                    .clamp(0.0, 1.0);
                return Padding(
                  padding: widget.enablePadding
                      ? const EdgeInsets.only(right: 7, left: 7)
                      : const EdgeInsets.all(0),
                  child: widget.enableParallax
                      ? Stack(
                    children: <Widget>[
                      SizedBox(
                          height: Curves.ease.transform(value) *
                              widget.height,
                          child: child),
                      Align(
                        alignment: widget.verticalAlignment ?? Alignment.center,
                        child: SizedBox(
                          height: Curves.ease.transform(value) *
                              widget.height,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius ??
                                    16.0),
                            child: Transform.translate(
                                offset: Offset(
                                    (_currentPageValue - position) *
                                        width /
                                        4,
                                    0),
                                child: SizedBox(
                                  width: width,
                                  height: widget.height,
                                  child: widget.items[position],
                                )),
                          ),
                        ),
                      )
                    ],
                  )
                      : SizedBox(
                    width: width,
                    height: widget.height,
                    child: widget.items[position],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
