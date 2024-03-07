//radius
import 'package:flutter/material.dart';

final BorderRadius borderRadiusFifteen = BorderRadius.circular(15);
final BorderRadius borderRadiusTen = BorderRadius.circular(10);
final BorderRadius borderRadiusEight = BorderRadius.circular(8);
final BorderRadius borderRadiusFive = BorderRadius.circular(5);
final BorderRadius borderRadiusTwenty = BorderRadius.circular(20);
final BorderRadius borderRadiusThirty = BorderRadius.circular(30);

//padding
const EdgeInsets paddingAllTwenty = EdgeInsets.all(20);
const EdgeInsets paddingAllTen = EdgeInsets.all(10);
const EdgeInsets paddingAllFifteen = EdgeInsets.all(15);
const EdgeInsets paddingAllEight = EdgeInsets.all(8);
const EdgeInsets paddingAllTwelve = EdgeInsets.all(12);
const EdgeInsets paddingAllFive = EdgeInsets.all(5);
const EdgeInsets paddingAllTwo = EdgeInsets.all(2);
const EdgeInsets paddingAllZero = EdgeInsets.all(0);

//spacing
const verticalSpaceEight = SizedBox(
  height: 8,
);
const horizontalSpaceEight = SizedBox(
  width: 8,
);
const verticalSpaceTwo = SizedBox(height: 2.0);
const verticalSpaceTen = SizedBox(height: 10.0);
const horizontalSpaceTen = SizedBox(width: 10.0);
const horizontalSpaceThirty = SizedBox(width: 30.0);
const verticalSpaceFive = SizedBox(
  height: 5,
);
const horizontalSpaceFive = SizedBox(width: 5.0);
const verticalSpaceTwelve = SizedBox(
  height: 12,
);
const horizontalSpaceTwelve = SizedBox(width: 12.0);
const horizontalSpaceFifteen = SizedBox(width: 15.0);
const horizontalSpaceTwenty = SizedBox(width: 20.0);
const horizontalSpaceTwo = SizedBox(width: 2.0);

const verticalSpaceEighteen = SizedBox(
  height: 18,
);
const verticalSpaceFifteen = SizedBox(
  height: 15,
);
const verticalSpaceTwenty = SizedBox(
  height: 20,
);
const verticalSpaceThirty = SizedBox(
  height: 30,
);

const shrinkedSizedBox = SizedBox.shrink();

//divider
final divider = Divider(
  thickness: .8,
  color: Colors.blueGrey.shade100.withOpacity(.5) ,
);

final dividerThin =  Divider(
  thickness: .8,height: 5,color: Colors.blueGrey.shade100.withOpacity(.4),
);


//loading widgets
late Widget loadingWidget30;
late Widget loadingWidget50;
late Widget loadingWidget70;
// final loadingWidgetLinear = ClipRRect(
//     borderRadius: BorderRadius.circular(3),
//     child: const LinearProgressIndicator(
//       color: kPrimaryColor,
//       minHeight: 2,
//       backgroundColor: Colors.transparent,
//     ));

//errors
const String errorUnknown = 'An unknown error occurred, please try again later';
const String errorNoInternet = 'Please connect to the internet to continue';
const String errorNotAvailable = 'Not Available';


late String imagesErrorPath;
late String imagesNoResultsPath;
late String imagesNoInternetPath;
late String imagesSuccessPath;

