import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

abstract class FullLifeCycleController extends RootController
    // ignore: prefer_mixin
    with WidgetsBindingObserver {}

mixin FullLifeCycleMixin on FullLifeCycleController {
  @mustCallSuper
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @mustCallSuper
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @mustCallSuper
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        onMinimised();
        break;
    }
  }

  void onResumed();
  void onPaused();
  void onInactive();
  void onDetached();
  void onMinimised();
}

class RootController extends ChangeNotifier {
  bool _mounted = true;
  bool isInitialized = false;
  double width = 0.0,height = 0.0;
  GoRouterState? routeState;

  bool get mounted => _mounted;

  RootController() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final size = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    width = size.width;
    height = size.height;
    onInit();
  }

  // @override
  // void notifyListeners() {
  //   if(!_mounted){
  //     return;
  //   }
  //   super.notifyListeners();
  // }

  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onReady();
    });
    isInitialized = true;
  }

  void onReady() {}

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
