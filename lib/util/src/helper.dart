

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../app_flavor/app_flavor.dart';
import 'constant.dart';

final logger = Logger();

String shortenLargeNumber(int number) {
  try {
    if (number >= 1000000000) {
        // Billion and more
        return '${(number / 1000000000).toStringAsFixed(1)} B';
      } else if (number >= 1000000) {
        // Million and more
        return '${(number / 1000000).toStringAsFixed(1)} M';
      } else if (number >= 1000) {
        // Thousand and more
        return '${(number / 1000).toStringAsFixed(1)} K';
      } else {
        // Less than 1000
        return number.toString();
      }
  } catch (e) {
    return '0';
  }
}


logInfo(data){
  if (AppFlavor.instance.flavor == AppFlavors.development) {
    logger.i(data);
  }
}

showErrorToast(String message) {
  showToast(message,
      backgroundColor: Colors.red,
      duration: const Duration(milliseconds: 5000));
}

showSuccessToast(String message) {
  showToast(message,
      backgroundColor: Colors.green,
      duration: const Duration(milliseconds: 5000));
}

bool isValidEmail(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern.toString());
  return regex.hasMatch(email);
}

Future<bool> isConnected() async {
  if (kIsWeb) {
    return Future.value(true);
  }
  bool finalResult = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      finalResult = true;
    }
  } on SocketException catch (_) {
    finalResult = false;
  }
  return finalResult;
}


copyText(String text) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
    showToast('Copied Successfully');
  } catch (e) {
    showErrorToast('Unable to copy, please try again later');
  }
}

bool textIsNumeric(String? s, {bool isDouble = false, String? ignoreChar}) {
  if (s == null || s.isEmpty) {
    return false;
  }
  if (ignoreChar != null) {
    s = s.replaceAll(ignoreChar, '');
  }
  try {
    return isDouble
        ? double.tryParse(s) != null && !s.contains('-')
        : int.tryParse(s) != null && !s.contains('-');
  } catch (e) {
    return false;
  }
}

String getHumanReadableFileSize({required int fileLength}) {
  double kBSize = fileLength / 1024;
  double mBSize = kBSize / 1024;
  return mBSize > 1 ? "${mBSize.round()} MB" : "${kBSize.round()} KB";
}

num getFileSizeMB({required int fileLength}) {
  double KBSize = fileLength / 1024;
  return KBSize / 1024.round();
}

num getFileSizeKB({@required fileLength}) {
  return (fileLength / 1024).round();
}

void openUrl(Uri uri) async {
  if (!await launchUrl(uri)) showErrorToast('Sorry, unable to load page');
}

String getAPIErrorMessage(Map<String, dynamic> data) {
  // Extracting the main error information
  final error = data['error'];
  final defaultMessage = error?['message'] ?? errorUnknown;
  final title = error?['name'] ?? '';

  // Extracting detailed error information if present
  final errorDetails = error?['details']?['errors'] as List<dynamic>? ?? [];

  if (errorDetails.isNotEmpty) {
    final messages = errorDetails.map((errorDetail) {
      final path = (errorDetail['path'] as List<dynamic>? ?? []).join(", ");
      final message = errorDetail['message'] ?? '';
      return '$path - $message';
    }).toList();

    return '$title: ${messages.join('; ')}';
  }

  // If there are no detailed errors, return the default message
  return '$title${title.isNotEmpty ? ': ' : ''}$defaultMessage';
}

// String getAPIErrorMessage(Map data) {
//   final message = data['error']?['message'] ?? errorUnknown;
//   final title = data['error']?['name'] ?? '';
//   if (title == 'BadRequestError') {
//     return message;
//   }
//   return '$title${title.isNotEmpty ? ', ' : ''}$message';
// }

sendEmail(
    {required String subject,required String email, String body = 'Hello,\n\n'}) async {
  try {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(
          <String, String>{'subject': subject, 'body': body}),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      launchUrl(emailLaunchUri);
    } else {
      showErrorToast(errorUnknown);
    }
  } catch (e) {
    showErrorToast(errorUnknown);
  }
}

String encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}


void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

void prettyPrintJson(object) {
  final prettyString = const JsonEncoder.withIndent('  ').convert(object);
  printWrapped(prettyString);
}


String getHumanReadableDateFromString(String timeStamp,
    {bool addWeekDay = false,
      bool addTimeOfDay = false,
      bool useTimeAgo = false,
      bool isOnlyTimeOfDay = false}) {
  try {
    final DateTime dateTime = DateTime.parse(timeStamp);
    final now = DateTime.now();
    if (useTimeAgo) {
      return (addTimeOfDay ? '${jmFormat.format(dateTime)}, ' : '') +
          (addWeekDay
              ? '${formatterWeekMonthDayYr.format(dateTime)} '
              : formatterMonthDayYr.format(dateTime));
    } else if (isOnlyTimeOfDay) {
      return jmFormat.format(dateTime);
    } else {
      return (addWeekDay
          ? '${formatterWeekMonthDayYr.format(dateTime)} '
          : (dateTime.day == now.day &&
          dateTime.month == now.month &&
          dateTime.year == now.year)
          ? 'Today'
          : formatterMonthDayYr.format(dateTime)) +
          (addTimeOfDay ? ', ${DateFormat('Hm').format(dateTime)}' : '');
    }
  } catch (e) {
    return '';
  }
}

String getErrorMsg(Map body) {
  String finalErrorMsg = '';
  if (body.containsKey('errors')) {
    final Map errors = body['errors'];
    for (String key in errors.keys) {
      finalErrorMsg = finalErrorMsg + errors[key].join(', ');
    }
  }
  if (body.containsKey('error')) {
    final Map errors = body['error'];
    finalErrorMsg = errors['message'];
  }
  if (finalErrorMsg.isEmpty) {
    finalErrorMsg =
    body['meta'] != null ? body['meta']['message'] : errorUnknown;
  }
  logger.i(body);
  return finalErrorMsg;
}

final jmFormat = DateFormat.jm();
final DateFormat formatterWeekMonthDayYr = DateFormat('EEEE MMMM d, yyyy');
final DateFormat formatterMonthDayYr = DateFormat('MMMM d, yyyy');

String getHumanReadableDate(int timeStamp,
    {bool addWeekDay = false,
      bool addTimeOfDay = false,
      bool useTimeAgo = false,
      bool isOnlyTimeOfDay = false}) {
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  final DateTime now = DateTime.now();
  if (useTimeAgo) {
    if (now.difference(dateTime).inDays > 2) {
      return (addTimeOfDay ? '${jmFormat.format(dateTime)}, ' : '') +
          (addWeekDay
              ? '${formatterWeekMonthDayYr.format(dateTime)} '
              : formatterMonthDayYr.format(dateTime));
    } else {
      return timeago.format(dateTime);
    }
  }
  if (isOnlyTimeOfDay) {
    return jmFormat.format(dateTime);
  } else {
    return (addTimeOfDay ? '${jmFormat.format(dateTime)}, ' : '') +
        (addWeekDay
            ? '${formatterWeekMonthDayYr.format(dateTime)} '
            : (dateTime.day == now.day &&
            dateTime.month == now.month &&
            dateTime.year == now.year)
            ? 'Today'
            : formatterMonthDayYr.format(dateTime));
  }
}

