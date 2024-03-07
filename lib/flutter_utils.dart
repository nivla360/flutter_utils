library flutter_utils;

import 'package:flutter/material.dart';

import 'util/src/constant.dart';

export 'state_management/state_management.dart';
export 'package:get_it/get_it.dart';
export 'package:go_router/go_router.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:ionicons/ionicons.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:flutter_styled_toast/flutter_styled_toast.dart';


class FlutterUtil {
  static void initialize({
    required Widget loaderSmall,
    required Widget loaderMedium,
    required Widget loaderLarge,
  required String imagesError,
  required String imagesNoResults,
  required String imagesNoInternet,
    String imagesSuccess = "packages/flutter_utils/assets/images/success.png"}) {
    loadingWidget30 = loaderSmall;
    loadingWidget50 = loaderMedium;
    loadingWidget70 = loaderLarge;
    imagesSuccessPath = imagesSuccess;
    imagesErrorPath = imagesError;
    imagesNoInternetPath = imagesNoInternet;
    imagesNoResultsPath = imagesNoResults;
  }
}
