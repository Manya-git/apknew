import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/payment/views/installation_options_view.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';

import '../../models/plan_model.dart';
import '../../utils/padding_utils.dart';

class ESimErrorDialog extends StatelessWidget {
  final PlanModel plan;
  const ESimErrorDialog({Key? key, required this.plan}) : super(key: key);

  Widget _spacer() => const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.kPurchageDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: Dimens.width(100, context),
        padding: const EdgeInsets.all(AppSizingUtils.topCurvedContainerRadius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            _spacer(),
            Text(
              AppString().pleaseInstalleSIM(context),
              style: FontUtils.TTFirsNeueTrial.copyWith(
                  fontSize: Dimens.currentSize(context, 12, 14, 16),
                  color: Colors.white,
                  height: 1.5,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            _spacer(),
            Center(child: button(context)),
          ],
        ),
      ),
    );
  }

  Widget button(BuildContext context) {
    return Container(
        height: Dimens.currentSize(context, 40, 45, 55),
        width: Dimens.width(100, context),
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: () => Get.to(() => InstallationOptionsView(isFromHome: true, iccid: plan.iccid!)),
          style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              );
            }),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return AppColors.bgButtonColor;
                } else if (states.contains(MaterialState.disabled)) {
                  return AppColors.bgButtonColor;
                }
                return AppColors.bgButtonColor;
              },
            ),
          ),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 0),
                alignment: Alignment.center,
                child: Text(
                  AppString().installationInstructions(context),
                  style: FontUtils.SF.copyWith(
                      fontSize: Dimens.currentSize(context, 14, 16, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.chevron_right, color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
