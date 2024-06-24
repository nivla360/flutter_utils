
import 'package:flutter_utils/util/src/helper.dart';

extension DynamicExt on dynamic{
  print({StackTrace? stackTrace}){
    logInfo(this,stackTrace: stackTrace);
  }
}