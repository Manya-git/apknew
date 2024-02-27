import 'package:flutter/material.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/loading_indicators.dart';

class PrimaryActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isDisable;

  const PrimaryActionButton(
      {Key? key, required this.label, required this.onTap, required this.isLoading, this.isDisable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Dimens.currentSize(context, 40, 45, 55),
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
                  return isDisable ? AppColors.kDisableButton : AppColors.kButtonColor;
                } else if (states.contains(MaterialState.disabled)) {
                  return isDisable ? AppColors.kDisableButton : AppColors.kButtonColor;
                }
                return isDisable ? AppColors.kDisableButton : AppColors.kButtonColor;
              },
            ),
          ),
          child: isLoading
              ? LoadingIndicators.circularIndicator(22, 2.5, Colors.white)
              : Container(
                  child: Text(
                    label,
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 14, 16, 18),
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
        ));
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const ActionButton({Key? key, required this.label, required this.onTap, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Dimens.currentSize(context, 40, 45, 55),
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
                  return AppColors.kButtonColor;
                } else if (states.contains(MaterialState.disabled)) {
                  return AppColors.kButtonColor;
                }
                return AppColors.kButtonColor;
              },
            ),
          ),
          child: isLoading
              ? LoadingIndicators.circularIndicator(22, 2.5, Colors.white)
              : Text(
                  label,
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
        ));
  }
}

class MiniActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool hasBorder;
  final bool isLoading;

  const MiniActionButton(
      {Key? key, required this.label, required this.onTap, required this.hasBorder, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Dimens.currentSize(context, 40, 50, 55),
        width: Dimens.width(100, context),
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
              return RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
            }),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return hasBorder ? AppColors.kButtonColor : AppColors.kSupportButton;
                } else if (states.contains(MaterialState.disabled)) {
                  return hasBorder ? AppColors.kButtonColor : AppColors.kSupportButton;
                }
                return hasBorder ? AppColors.kButtonColor : AppColors.kSupportButton;
              },
            ),
          ),
          child: SizedBox(
            child: isLoading
                ? LoadingIndicators.circularIndicator(22, 2.5, Colors.white)
                : Text(
                    label,
                    style: FontUtils.SF.copyWith(
                        fontSize: Dimens.currentSize(context, 16, 18, 18),
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
          ),
        ));
  }
}
