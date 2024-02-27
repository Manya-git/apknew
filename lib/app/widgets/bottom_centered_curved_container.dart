import 'package:flutter/material.dart';
import 'package:ride_mobile/app/utils/colors.dart';

import '../utils/dimensions.dart';
import '../utils/padding_utils.dart';

class BottomCenteredCurvedContainer extends StatelessWidget {
  final double height;
  final Widget child;
  final double? vPad;

  const BottomCenteredCurvedContainer({Key? key, required this.height, required this.child, this.vPad})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: height,
          width: Dimens.width(100, context),
          padding: EdgeInsets.symmetric(
              horizontal: AppSizingUtils.kCommonSpacing, vertical: vPad ?? AppSizingUtils.kCommonSpacing),
          decoration: BoxDecoration(
            color: AppColors.kRectangleColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizingUtils.topCurvedContainerRadius),
                topRight: Radius.circular(AppSizingUtils.topCurvedContainerRadius)),
            shape: BoxShape.rectangle,
          ),
          child: child),
    );
  }
}
