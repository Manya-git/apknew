import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';

import '../../utils/colors.dart';

class CustomPrefixIcon extends StatelessWidget {
  final IconData icon;
  const CustomPrefixIcon({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Icon(
          icon,
          color:Colors.white,
          size: Dimens.currentSize(context, 20, 23, 23),
        ));
  }
}
