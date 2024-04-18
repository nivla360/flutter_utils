
import 'package:flutter/material.dart';

class ReactiveValueWidget<T extends ValueNotifier<dynamic>> extends StatelessWidget {
  final T notifier;
  final Widget Function(BuildContext context, T value) builder;

  const ReactiveValueWidget({
    required this.notifier,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<dynamic>(
      valueListenable: notifier,
      builder: (context, value, child) {
        return builder(context, notifier);
      },
    );
  }
}