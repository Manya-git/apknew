import 'package:flutter/material.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

class NoResultFoundCard extends StatelessWidget {
  final String message;

  const NoResultFoundCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        color: Colors.transparent,
        child: Center(
            child: Text(
          message,
          style: FontUtils.SF.copyWith(fontSize: 15, color: FontColors.kHintColor),
        )));
  }
}
