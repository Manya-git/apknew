import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/keys.dart';

class ArrowedBackButton extends StatelessWidget {
  final int? icon;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool? isFromHome;
  final String? textWithButton;

  const ArrowedBackButton(
      {Key? key, this.icon, this.horizontalPadding, this.verticalPadding, this.isFromHome, this.textWithButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isFromHome ?? false
            ? const SizedBox(
                height: 40,
                width: 40,
              )
            : InkWell(
                splashColor: Colors.transparent,
                key: CommonKeys.goBackButtonKey,
                onTap: () => Get.back(),
                child: SvgPicture.asset(
                  Assets.back_arrow,
                  color: Colors.white,
                  height: 40,
                  width: 40,
                ),
              ),
        // const SmallLogoCard()
      ],
    );
  }
}
