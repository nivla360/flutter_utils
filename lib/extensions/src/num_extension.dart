import 'package:flutter/cupertino.dart';


extension NumExt on num {

  Widget get vs => SizedBox(height: toDouble(),); //vertical space

  Widget get hs => SizedBox(width: toDouble(),); //horizontal space

  Duration get seconds => Duration(seconds: toInt());

  Duration get milliSeconds => Duration(milliseconds: toInt());

  Future get futureSeconds => Future.delayed(Duration(seconds: toInt()));

  Future get futureMilliSeconds => Future.delayed(Duration(milliseconds: toInt()));

}