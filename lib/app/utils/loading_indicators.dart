import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicators {
  static Center circularIndicator(double hw, double sw, Color color) {
    return Center(
      key: const Key("circular_loading_indicator"),
        child: SizedBox(
            height: hw,
            width: hw,
            child: Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: sw,
            ))));
  }

  static Center cupertinoIndicator(double radius, Color color) {
    return Center(
        child: CupertinoActivityIndicator(
          radius: radius,
          color: color,
        ));
  }

}
