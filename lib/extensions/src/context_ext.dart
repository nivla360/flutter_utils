
import 'package:flutter/material.dart';
import 'package:flutter_utils/extensions/extensions.dart';
import 'package:flutter_utils/widgets/src/platform_image_asset.dart';
import 'package:go_router/go_router.dart';

import '../../util/src/constant.dart';
import '../../widgets/widgets.dart';


extension ContextExt on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  bool get screenIsMobile => width <= 600;

  bool get screenIsTablet => width >= 600 && width < 1100;

  bool get screenIsDesktop => width > 1100;

  ThemeData get theme => Theme.of(this);

  Color get scaffoldBgColor => Theme.of(this).scaffoldBackgroundColor;

  bool get isDialogOpen => ModalRoute.of(this)?.isCurrent != true;

  Brightness get brightness => MediaQuery.of(this).platformBrightness;

  bool get isDarkMode => brightness == Brightness.dark;

  TextStyle? get appBarTitleStyle => theme.appBarTheme.titleTextStyle;

  TextTheme? get textTheme => theme.textTheme;

  showSnackBar(String message, {Color? bgColor}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        backgroundColor: bgColor,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.only(bottom: height - 200, right: 20, left: 20)));
  }

  Future<T?> _showBottomSheet<T>({
    required Widget child,
    Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    ShapeBorder? shape,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) => showModalBottomSheet(
      context: this,
      builder: (_) => child,
      backgroundColor: backgroundColor,
      barrierLabel: barrierLabel,
      elevation: elevation,
      shape: shape,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );


  showCustomModal({
    String? title,
    Widget? bottomButton,
    EdgeInsetsGeometry padding = const EdgeInsets.all(15),
    List<Widget> actions = const [],
    required Widget child,
  }) {
    const borderRadius = Radius.circular(15);
    _showBottomSheet(
      child: CustomModal(
          title: title,
          bottomButton: bottomButton,
          padding: padding,
          actions: actions,
          child: child),
      backgroundColor: theme.scaffoldBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.only(topRight: borderRadius, topLeft: borderRadius),
      ),
    );
  }

  Future<dynamic> showCustomDialog({
    required Widget child,
    bool barrierDismissible = true,
  })=> showDialog<dynamic>(
        context: this,
        builder: (_) => child,
        barrierDismissible: barrierDismissible);

  Future<dynamic> showSimpleCustomDialog({
    bool barrierDismissible = true,
    required String title,
    required String description,
    List<Widget> actions = const [],
    bool showOkButton = true
  }) async {
    if (actions.isEmpty) {
      actions = [];
      if(showOkButton) {
        actions.add(
        TextButton(onPressed: pop, child: const Text('OK')),
      );
      }
    }
    final result = await showDialog<dynamic>(
        context: this,
        builder: (_) {
          return AlertDialog(
            title: Text(
              title,
              style: theme.appBarTheme.titleTextStyle!.copyWith(fontSize: 20),
            ),
            shape: RoundedRectangleBorder(borderRadius: borderRadiusFifteen),
            content: Text(description),
            actions: actions,
          );
        },
        barrierDismissible: barrierDismissible);
    return result;
  }

  Future showLoadingDialog(
      {bool barrierDismissible = true,
        String title = 'Please Wait...',
        String? message,
        bool showCancelButton = false,
        VoidCallback? onCancel}) => showDialog(
        context: this,
        builder: (_) => PopScope(
            child: AlertDialog(
              title: Text(
                title,
                style: theme.appBarTheme.titleTextStyle!.copyWith(fontSize: 20),
              ),
              shape: RoundedRectangleBorder(borderRadius: borderRadiusFifteen),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loadingWidget70,
                  if (message != null) ...[
                    verticalSpaceFive,
                    Text(
                      message,
                      style: textTheme!.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ]
                ],
              ),
              actions: showCancelButton
                  ? [
                TextButton(
                    onPressed: onCancel ?? pop,
                    child: const Text("Cancel"))
              ]
                  : null,
            ),
            onPopInvoked: (bool didPop) {
              // return Future.value(barrierDismissible);
            }),
        barrierDismissible: barrierDismissible);

  Future<dynamic> showErrorDialog(
      {bool barrierDismissible = true,
        bool shouldRetry = false,
        VoidCallback? onRetry,
        String? description,
        String retryButtonLabel = 'OKAY',
        String? title}) async {
    if (isDialogOpen) {
      pop();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    // isDialogOpen = true;
    final result = await showDialog(
      context: this,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: borderRadiusFifteen),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ErrorView(
              title: title,
              subtitle: description,
              onRetry: onRetry ?? pop,
              retryButtonLabel: retryButtonLabel,
            )
          ],
        ),
      ),
    );
    return result;
  }

  Future showSuccessDialog(
      {bool barrierDismissible = true,
        Function? onOkayTap,
        String? description,
        String title = 'Success!'}) async {
    if (isDialogOpen) {
      pop();
      await Future.delayed(const Duration(milliseconds: 300));
    }
    final result = await showDialog(
      context: this,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: borderRadiusFifteen),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // PlatformImageAsset(
            //  imagesSuccessPath,
            //   height: 150,
            //   width: 150,
            // ),
            PlatformImageAsset(
              imagesSuccessPath,
              width: 150,
              height: 150, // / 1.2,
              color: theme.primaryColor,
              fit: BoxFit.cover,
            ).clipAllCorners(10),
            verticalSpaceFive,
            Text(
              title,
              style: theme.appBarTheme.titleTextStyle,
            ),
            Text(description ?? 'Process completed successfully')
                .paddingOnly(top: 5, bottom: 15),
            TextButton(
              onPressed: () async {
                pop();
                if (onOkayTap != null) {
                  onOkayTap();
                }
              },
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                  shape: const StadiumBorder(),
                  backgroundColor: theme.primaryColor,
              ),
              child: Text(
                'OKAY',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : null,
                ),
              ),
            )
          ],
        ),
      ),
    );
    return result;
  }

  Future<bool?> showDialogWithBooleanResult(
      {required String title,
        required String message,
        bool depictButtonColors = true,
        Color? messageColor,
        String negativeButtonLabel = 'NO',
        String positiveButtonLabel = 'YES'}) => showDialog(
      context: this,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          title,
          style: theme.appBarTheme.titleTextStyle!.copyWith(fontSize: 22),
        ),
        content: Text(
          message,
          style: TextStyle(color: messageColor),
        ),
        actions: [
          TextButton(
            onPressed: () => pop(false),
            child: Text(
              negativeButtonLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          TextButton(
              onPressed: () => pop(true),
              child: Text(
                positiveButtonLabel,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: depictButtonColors ? Colors.red : null),
              )),
        ],
      ),
      barrierDismissible: false,
    );

  showNoInternetDialog(
      {bool barrierDismissible = true,
        bool shouldRetry = false,
        VoidCallback? onRetry,
        String message = errorNoInternet}) async {
    if (isDialogOpen) {
      pop();
      await Future.delayed(const Duration(milliseconds: 300));
    }
    final result = await showDialog(
        context: this,
        builder: (_) => PopScope(
          child: AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: borderRadiusFifteen),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagesNoInternetPath,
                  height: 200,
                  fit: BoxFit.fitHeight,
                ).clipAllCorners(10),
                verticalSpaceTen,
                Text(
                  'No Internet',
                  style: theme.appBarTheme.titleTextStyle,
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                verticalSpaceTwenty,
                TextButton(
                  onPressed: () async {
                    pop();
                    if (shouldRetry) {
                      await Future.delayed(
                          const Duration(milliseconds: 300));
                      if (onRetry != null) {
                        onRetry();
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 60),
                      shape: const StadiumBorder(),
                      backgroundColor: theme.primaryColor,
                  ),
                  child: Text(
                    shouldRetry ? 'RETRY' : 'OKAY',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          // onPopInvoked: () async {
          //   return await Future.value(barrierDismissible);
          // },
        ),
        barrierDismissible: barrierDismissible);
    return result;
  }

// EdgeInsetsGeometry get pagePadding => screenIsMobile ? paddingAllFifteen : paddingAllThirty;

// TextStyle get sectionStyle =>  theme.appBarTheme.titleTextStyle!.copyWith(fontSize: .02.sh,color: Colors.grey.shade700);
}
