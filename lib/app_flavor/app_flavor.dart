

import 'package:flutter/cupertino.dart';

enum AppFlavors { development, staging, production, }

typedef Configure = Future<void> Function();

class AppFlavor {
  AppFlavors flavor = AppFlavors.production;
  static final AppFlavor _appFlavor = AppFlavor._internal();

  bool get isDevelopment => flavor == AppFlavors.development;
  bool get isProduction => flavor == AppFlavors.production;
  bool get isStaging => flavor == AppFlavors.staging;

  factory AppFlavor() {
    return _appFlavor;
  }

  AppFlavor._internal();

  static AppFlavor get instance => _appFlavor;


  Future init(AppFlavors appFlavor,{Configure? configure}) async {
    flavor = appFlavor;
    if(configure != null){
      await configure();
    }
  }
}