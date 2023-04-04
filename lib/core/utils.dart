import 'package:flutter/material.dart';

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double heightWithScreenRatio(BuildContext context, double ratio) =>
    screenHeight(context) * ratio;
double widthWithScreenRatio(BuildContext context, double ratio) =>
    screenWidth(context) * ratio;

class Spacing {
  SizedBox verticalSpace(double value) => SizedBox(height: value);
  SizedBox horizontalSpace(double value) => SizedBox(width: value);
  SizedBox verticalSpaceWithRatio(BuildContext context, double ratio) =>
      SizedBox(
        height: heightWithScreenRatio(context, ratio),
      );
  SizedBox horizontalSpaceWithRatio(BuildContext context, double ratio) =>
      SizedBox(
        width: widthWithScreenRatio(context, ratio),
      );
}
