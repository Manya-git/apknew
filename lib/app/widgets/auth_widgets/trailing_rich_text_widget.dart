import 'package:flutter/material.dart';
import 'package:ride_mobile/app/utils/colors.dart';

import '../../utils/dimensions.dart';
import '../../utils/font_utils.dart';

class TrailingRichTextWidget extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final VoidCallback onTap;
  const TrailingRichTextWidget({Key? key, required this.leftLabel, required this.rightLabel, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      width: Dimens.width(100, context),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 12, 14, 18), color: Colors.white, fontWeight: FontWeight.w400),
            children: [
              TextSpan(
                text: "$leftLabel ",
              ),
              TextSpan(
                  text: rightLabel,
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 12, 14, 18),
                      color: FontColors.kBlueColor,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}
