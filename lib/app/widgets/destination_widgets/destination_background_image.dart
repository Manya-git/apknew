import 'package:flutter/material.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';

class DestinationBackgroundImage extends StatelessWidget {
  final Widget child;
  const DestinationBackgroundImage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      width: Dimens.width(100, context),
      child: Container(
          height: 270,
          width: Dimens.width(100, context),
          decoration: BoxDecoration(
              color: AppColors.kRectangleColor,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
          child: child),
    );
  }
}

class PaymentBackgroundImage extends StatelessWidget {
  final double height;
  const PaymentBackgroundImage({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "",
      fit: BoxFit.cover,
      height: height,
      width: Dimens.width(100, context),
      // key: DestinationPageKeys.destinationHeaderImageKey,
    );
  }
}
