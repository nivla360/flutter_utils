import 'package:flutter/material.dart';
import 'package:flutter_utils/extensions/extensions.dart';
import 'package:flutter_utils/util/src/constant.dart';
import 'package:ionicons/ionicons.dart';

import 'platform_image_asset.dart';

enum _ErrorType { noInternet, generalError, noResults, onLoadMoreError }

String? _image, _title, _subtitle;

class ErrorView extends StatelessWidget {
  final _ErrorType _errorType;
  final VoidCallback? onRetry;
  final bool isChat;
  final String? imageAsset, title, subtitle, retryButtonLabel;
  final IconData? icon;
  final Color? iconColor;
  final double imageSize;

  const ErrorView(
      {Key? key,
      this.onRetry,
      this.imageSize = 250,
      this.isChat = false,
      this.retryButtonLabel = 'Retry',
      this.title,
      this.subtitle,
      this.imageAsset,
      this.icon,
      this.iconColor})
      : _errorType = _ErrorType.generalError,
        super(key: key);

  const ErrorView.noInternet(
      {Key? key,
      this.onRetry,
      this.imageSize = 250,
      this.isChat = false,
      this.retryButtonLabel = 'Retry',
      this.title,
      this.subtitle,
      this.icon,
      this.iconColor,
      this.imageAsset})
      : _errorType = _ErrorType.noInternet,
        super(key: key);

  const ErrorView.noResult({
    Key? key,
    this.onRetry,
    this.imageSize = 250,
    this.isChat = false,
    this.title,
    this.subtitle,
    this.retryButtonLabel = 'Retry',
    this.imageAsset,
    this.icon,
    this.iconColor,
  })  : _errorType = _ErrorType.noResults,
        super(key: key);

  const ErrorView.onLoadMoreError({
    Key? key,
    this.onRetry,
    this.imageSize = 250,
    this.isChat = false,
    this.title,
    this.subtitle,
    this.retryButtonLabel = 'Retry',
    this.imageAsset,
    this.icon,
    this.iconColor,
  })  : _errorType = _ErrorType.onLoadMoreError,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _init();
    return _errorType == _ErrorType.onLoadMoreError
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(
                label: Text(
                  _subtitle ?? '',
                  style: const TextStyle(color: Colors.red),
                ),
                avatar: const Icon(
                  Ionicons.alert_circle,
                  color: Colors.red,
                  // size: 20,
                ),
                backgroundColor: Colors.red.withOpacity(.2),
              ),
              if (onRetry != null) horizontalSpaceTwenty,
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                      // backgroundColor: kPrimaryColor,
                      shape: const StadiumBorder()),
                  child: Text(
                    retryButtonLabel ?? 'Retry',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
            ],
          )
        : Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon != null
                      ? Container(
                          decoration: BoxDecoration(
                            color: iconColor?.withValues(alpha: 0.1) ??
                                Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(imageSize),
                          ),
                          child: Icon(
                            icon,
                            size: imageSize,
                            color: iconColor ?? context.theme.primaryColor,
                          ).paddingAll(20),
                        ).paddingOnly(bottom: 16)
                      : PlatformImageAsset(
                          imageAsset ??
                              _image ??
                              imagesErrorPath, //Assets.images.error.path,
                          width: imageSize,
                          height: imageSize / 1.2,
                          fit: BoxFit.cover,
                        ).clipAllCorners(10),
                  // verticalSpaceTen,
                  Text(
                    _title ?? '',
                    textAlign: TextAlign.center,
                    style: context.theme.appBarTheme.titleTextStyle!
                        .copyWith(fontSize: 25),
                  ),
                  Text(
                    _subtitle ?? '',
                    textAlign: TextAlign.center,
                  ),
                  if (onRetry != null) ...[
                    verticalSpaceTen,
                    TextButton(
                      onPressed: onRetry,
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 60),
                          shape: const StadiumBorder(),
                          backgroundColor: context.theme.primaryColor),
                      child: Text(retryButtonLabel ?? 'Retry',
                          style: const TextStyle(color: Colors.white)),
                    )
                  ]
                ],
              ),
            ),
          );
  }

  _init() {
    switch (_errorType) {
      case _ErrorType.noInternet:
        _image = imagesNoInternetPath; //Assets.images.noInternet.path;
        _title = title ?? 'Connection Lost';
        _subtitle = subtitle ?? 'Please make sure you have internet connection';
        break;
      case _ErrorType.generalError:
        _image = imagesErrorPath; //Assets.images.error.path;
        _title = title ?? 'Oops...';
        _subtitle = subtitle ?? 'That was unexpected, please try again later';
        break;
      case _ErrorType.noResults:
        _image = imagesNoResultsPath; //Assets.images.empty.path;
        _title = title ?? 'Nothing found';
        _subtitle = subtitle ?? 'Sorry, nothing to show here';
        break;
      case _ErrorType.onLoadMoreError:
        _image = imagesErrorPath; //Assets.images.error.path;
        _title = title ?? '';
        _subtitle = subtitle ?? 'An error occurred';
        break;
    }
  }
}
