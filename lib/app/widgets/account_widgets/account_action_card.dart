import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';

import '../../utils/font_utils.dart';

class AccountActionCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onPressed;

  const AccountActionCard({Key? key, required this.title, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.currentSize(context, 40, 45, 50),
      child: Container(
        decoration: BoxDecoration(color: AppColors.kSupportButton, borderRadius: BorderRadius.circular(25)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon != ""
                    ? SvgPicture.asset(
                        icon,
                        height: 24,
                        width: 24,
                        color: AppColors.bgButtonColor,
                      )
                    : Container(width: 24),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 14, 16, 18),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 24,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
