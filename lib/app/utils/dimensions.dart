import 'dart:io';

import 'package:flutter/material.dart';

class Dimens {
  static double height(double i, BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return h * i / 100;
  }

  static double width(double i, BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return w * i / 100;
  }

  static double fs(double i, BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return w / 100 * (i / 3);
  }

  static double currentSize(BuildContext context, double smallMobile, double mobile, double tablet) {
    double w = MediaQuery.of(context).size.height;

    if (w <= 740) {
      return mobile;
    } else if (w <= 1000) {
      return mobile;
    } else {
      return mobile;
    }
  }

  static double getStatusBarHeight(BuildContext context) {
    if (Platform.isAndroid) {
      return Dimens.height(6, context);
    } else {
      return Dimens.height(7, context);
    }
  }

  static double lineHeight() {
    return 1.7;
  }
}
