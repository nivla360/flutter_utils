
import 'package:flutter/material.dart';

extension WidgetExt on Widget{
  Widget clipAllCorners(double radius){
    return ClipRRect(borderRadius: BorderRadius.circular(radius),child: this,);
  }

  Widget onTap(VoidCallback onTap)=>InkWell(onTap: onTap,child: this,);

  Widget expanded()=> Expanded(child: this);


  Widget outlined({
    Color? color ,
    double width = 1.0,
    double radius = 15,
  }) => Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: color ?? Colors.blueGrey.shade100.withOpacity(.5),
        width: width,
      ),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    ),
    child: this,
  );

  Widget center()=>Center(child: this,);

  Widget clipOnlyCorners(
      {double topLeft = 0,
        double topRight = 0,
        double bottomLeft = 0,
        double bottomRight = 0}) =>
      ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft),
            topRight: Radius.circular(topRight),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight)),
        child: this,
      );

  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
          padding:
          EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

}