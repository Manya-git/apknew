import 'package:flutter/material.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/colors.dart';

import '../../utils/dimensions.dart';
import '../../utils/font_utils.dart';

class ResendCodeButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const ResendCodeButton({Key? key, required this.color, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 30,
        child: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: FontUtils.TTFirsNeueTrial.copyWith(
                fontSize: Dimens.currentSize(context, 12, 14, 16), color: color, fontWeight: FontWeight.w400),
            children: [
              TextSpan(
                text: AppString().didntReceiveCode(context),
              ),
              TextSpan(
                  text: AppString().resendCode(context),
                  style: FontUtils.TTFirsNeueTrial.copyWith(
                      fontSize: Dimens.currentSize(context, 12, 14, 16),
                      color: AppColors.bgButtonColor,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
