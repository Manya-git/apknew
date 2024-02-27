import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/models/plan_model.dart';
import 'package:ride_mobile/app/modules/payment/controllers/payment_controller.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/padding_utils.dart';
import 'package:ride_mobile/app/widgets/buttons/primary_action_button.dart';

import '../../../utils/appString.dart';
import '../../../utils/assets.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/keys.dart';
import '../../../widgets/bottom_centered_curved_container.dart';

class ImportantConfirmationView extends GetView<PaymentController> {
  final PlanModel plan;
  final String transactionId;

  const ImportantConfirmationView({Key? key, required this.plan, required this.transactionId}) : super(key: key);

  String get title =>
      !controller.isManual.value ? AppString().not_manually(Get.context!) : AppString().is_manually(Get.context!);

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentController());
    return Scaffold(
        backgroundColor: AppColors.homeBGColor,
        body: Stack(
          children: [
            Image.asset(
              Assets.shop_bg,
              fit: BoxFit.fill,
              height: Dimens.height(100, context),
              width: Dimens.width(100, context),
              alignment: Alignment.topLeft,
              key: DestinationPageKeys.destinationHeaderImageKey,
            ),
            Positioned(
              top: 70,
              child: Image.asset(
                Assets.img_desgin,
                fit: BoxFit.fill,
                height: 100,
                width: Dimens.width(100, context),
                alignment: Alignment.topLeft,
              ),
            ),
            BottomCenteredCurvedContainer(
                height: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(AppString().important(context),
                        style: FontUtils.TTFirsNeueTrial.copyWith(
                            fontSize: Dimens.currentSize(context, 18, 20, 22),
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(
                      height: 10,
                    ),
                    !controller.isManual.value
                        ? Text(
                            "YOU CAN ONLY HAVE ONE ONE PLAN ACTIVATED AT A TIME FROM THESE SET OF PLANS.",
                            style: FontUtils.TTFirsNeueTrial.copyWith(
                                fontSize: Dimens.currentSize(context, 14, 12, 18),
                                color: Colors.white,
                                height: Dimens.lineHeight(),
                                fontWeight: FontWeight.w500),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      title,
                      style: FontUtils.SF.copyWith(
                          fontSize: Dimens.currentSize(context, 14, 14, 18),
                          color: Colors.white,
                          height: Dimens.lineHeight(),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MiniActionButton(
                            label: AppString().go_back(context),
                            onTap: () {
                              Get.back();
                              //stop loading...
                              controller.isContinueLoading.value = false;
                            },
                            hasBorder: false,
                            isLoading: false,
                          ),
                        ),
                        const SizedBox(width: AppSizingUtils.kCommonSpacing),
                        Obx(
                          () => Expanded(
                            child: MiniActionButton(
                              label: !controller.isManual.value
                                  ? AppString().continue_key(context)
                                  : AppString().go_home(context),
                              onTap: () => controller.onTapContinue(plan, transactionId),
                              hasBorder: true,
                              isLoading: controller.isContinueLoading.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ));
  }
}
