import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/loading_indicators.dart';

import '../../utils/assets.dart';

class AuthActionButton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color fontColor;
  final bool hasBorder;
  final bool hasArrow;
  final VoidCallback onTap;
  final bool isLoading;

  const AuthActionButton(
      {Key? key,
      required this.label,
      required this.bgColor,
      required this.hasBorder,
      required this.hasArrow,
      required this.fontColor,
      required this.onTap,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Dimens.currentSize(context, 40, 45, 60),
        width: Dimens.width(100, context),
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              );
            }),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return bgColor;
                } else if (states.contains(MaterialState.disabled)) {
                  return bgColor;
                }
                return bgColor;
              },
            ),
          ),
          child: isLoading
              ? LoadingIndicators.circularIndicator(22, 2.5, Colors.white)
              : Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 0),
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: FontUtils.SF.copyWith(
                            fontSize: Dimens.currentSize(context, 14, 16, 18),
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    hasArrow
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: SvgPicture.asset(Assets.forwardIcon, height: 15, width: 15, fit: BoxFit.cover),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
        ));
  }
}
