import 'package:flutter/material.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';

import '../../utils/padding_utils.dart';

class CurvedWhiteContainerRegistration extends StatelessWidget {
  final Widget child;

  const CurvedWhiteContainerRegistration({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizingUtils.kCommonSpacing,
            vertical: AppSizingUtils.kCommonSpacing),
        height: Dimens.height(100, context) - 100,
        width: Dimens.width(100, context),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizingUtils.topCurvedContainerRadius),
              topRight: Radius.circular(AppSizingUtils.topCurvedContainerRadius)),
          shape: BoxShape.rectangle,
        ),
        child: child,
      ),
    );
  }
}
