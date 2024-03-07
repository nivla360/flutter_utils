import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import './root_controller.dart';


// class ReactivePage extends AnimatedWidget {
//   const ReactivePage({
//     Key? key,
//     required this.controller,
//     required this.builder,
//   }) : super(
//     key: key,
//     listenable: controller,
//   );
//
//
//
//   ///A controller that the UI listens to for changes.
//   final Listenable controller;
//
//   /// Called every time the controller notifies the UI
//   /// to rebuild.
//   final Widget Function(BuildContext) builder;
//
//   @override
//   Widget build(BuildContext context) {
//     // StatefulBuilder(builder: ,)
//     return builder(context);
//   }
// }

class ReactiveWidget<T extends RootController> extends StatefulWidget {
  // final T? controller;
  final Widget Function(BuildContext context, T controller) builder;

  const ReactiveWidget({
     super.key,
    // this.controller,
    required this.builder,
  });

  @override
  State<ReactiveWidget<T>> createState() => _ReactiveWidgetState<T>();
}

class _ReactiveWidgetState<T extends RootController> extends State<ReactiveWidget<T>> {
  T? controller;

  @override
  void initState() {
    controller = GetIt.I.get<T>();
    controller?.addListener(_handleChange);
    super.initState();
  }

  @override
  void dispose() {
    controller?.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, controller!);
}

// class ReactiveValueWidget<T extends BaseController> extends StatefulWidget {
//   // final dynamic value;
//   final ValueNotifier valueNotifier;
//
//   final Widget Function(BuildContext context, T controller) builder;
//
//   const ReactiveValueWidget({
//     Key? key,
//     required this.valueNotifier,
//     required this.builder,
//   }) : super(key: key);
//
//   @override
//   State<ReactiveValueWidget<T>> createState() => _ReactiveValueWidgetState<T>();
// }
//
// class _ReactiveValueWidgetState<T extends BaseController> extends State<ReactiveValueWidget<T>> {
//   late T controller;
//   // late ValueNotifier<dynamic> rebuildNotifier;
//
//   @override
//   void initState() {
//     super.initState();
//     // controller = widget.controller;
//     controller = GetIt.I.get<T>();
//     // rebuildNotifier = ValueNotifier<dynamic>(widget.value);
//
//     controller.addListener(_handleChange);
//   }
//
//   @override
//   void dispose() {
//     controller.removeListener(_handleChange);
//     widget.valueNotifier.dispose();
//     super.dispose();
//   }
//
//   void _handleChange() {
//     if (mounted) {
//       widget.valueNotifier.value = widget.value;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<dynamic>(
//       valueListenable: rebuildNotifier,
//       builder: (context, _, child) {
//         return widget.builder(context, controller);
//       },
//     );
//   }
// }