
import 'package:flutter_utils/util/src/helper.dart';

extension DynamicExt on dynamic{
  print(){
    logInfo(this);
  }
}