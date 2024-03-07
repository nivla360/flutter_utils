

import 'package:flutter/cupertino.dart';

enum AppFlavors { development, staging, production, }


class AppFlavor {
  AppFlavors flavor = AppFlavors.production;
  static final AppFlavor _appFlavor = AppFlavor._internal();

  bool get isDev => flavor == AppFlavors.development;
  bool get isProduction => flavor == AppFlavors.production;
  bool get isStaging => flavor == AppFlavors.staging;

  factory AppFlavor() {
    return _appFlavor;
  }

  AppFlavor._internal();

  static AppFlavor get instance => _appFlavor;

  Future init(AppFlavors appFlavor,{VoidCallback? configure}) async {
    flavor = appFlavor;
    if(configure != null){
      configure();
    }
  }
}