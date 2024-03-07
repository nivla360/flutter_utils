
import 'package:example/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';

class BaseController extends RootController{
  GoRouter router = AppRoute.router;

  BuildContext? getContext(){
    return router.configuration.navigatorKey.currentContext;
  }
}