import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/dimensions.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/widgets/buttons/close_button_dialog.dart';

import '../../utils/padding_utils.dart';
import '../buttons/rounded_border_button.dart';

class PlanExpireDialog extends GetView<AccountController> {
  final String page;
  final PlanModel plan;
  const PlanExpireDialog({Key? key, required this.plan, required this.page}) : super(key: key);

  Widget _spacer() => const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Dialog(
      backgroundColor: AppColors.kPurchageDialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizingUtils.dialogBorderRadius),
      ),
      child: Container(
        width: Dimens.width(100, context),
        padding: const EdgeInsets.all(AppSizingUtils.kCommonSpacingD),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CloseButtonDialog()],
            ),
            _spacer(),
            Text(
              AppString().youHaveActivePlan(context),
              style: FontUtils.TTFirsNeueTrial.copyWith(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
            ),
            _spacer(),
            Text(
              AppString().youHaveActivePlanDetails(context),
              style: FontUtils.SF.copyWith(fontSize: 14, color: FontColors.white71, height: 1.5),
              textAlign: TextAlign.center,
            ),
            _spacer(),
            Center(
              child: RoundedBorderButton(
                text: AppString().continue_key(context),
                onPressed: () {
                  controller.isWarned = true;
                  Get.back();
                  controller.openESIMErrorDialog(plan, page);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
