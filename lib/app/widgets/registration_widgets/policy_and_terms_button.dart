import 'package:flutter/material.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

class PolicyAndTermsButton extends StatelessWidget {
  final String label;
  final bool isAccepted;
  final VoidCallback onTapIcon;
  final VoidCallback onTap;
  final Key radioButtonKey;
  final Key textButtonKey;
  final String title;
  final String? description;

  const PolicyAndTermsButton(
      {Key? key,
      required this.label,
      required this.isAccepted,
      required this.onTapIcon,
      required this.onTap,
      required this.radioButtonKey,
      required this.title,
      this.description,
      required this.textButtonKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: AppColors.navigation_icon_bg,
                side: BorderSide(width: 1, color: AppColors.navigation_icon_bg),
                value: isAccepted,
                checkColor: Colors.black,
                onChanged: (val) => onTapIcon()),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: FontUtils.SF.copyWith(
                    fontSize: Dimens.currentSize(context, 12, 14, 16),
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: label + " ",
                    ),
                    TextSpan(
                        text: title,
                        style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 12, 14, 16),
                          color: AppColors.navigation_icon_bg,
                          fontWeight: FontWeight.bold,
                          // decoration: TextDecoration.underline,
                        )),
                    TextSpan(
                      text: description ?? "",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
