import 'package:flutter/cupertino.dart';


// final heightScaleFactor = height / baseScreenHeight;


extension NumExt on num {

  Widget get verticalSpace => SizedBox(height: toDouble(),);

  Widget get horizontalSpace => SizedBox(width: toDouble(),);

  Duration get seconds => Duration(seconds: toInt());

  Duration get milliSeconds => Duration(milliseconds: toInt());

  Future get futureSeconds => Future.delayed(Duration(seconds: toInt()));

  Future get futureMilliSeconds => Future.delayed(Duration(milliseconds: toInt()));

}