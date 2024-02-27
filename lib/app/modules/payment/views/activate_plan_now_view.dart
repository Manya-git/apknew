import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/payment/controllers/payment_controller.dart';
import 'package:ride_mobile/app/utils/appString.dart';
import 'package:ride_mobile/app/utils/assets.dart';
import 'package:ride_mobile/app/utils/colors.dart';
import 'package:ride_mobile/app/utils/font_utils.dart';
import 'package:ride_mobile/app/utils/plan_utils.dart';
import 'package:ride_mobile/app/widgets/buttons/primary_action_button.dart';

import '../../../models/plan_model.dart';
import '../../../services/user/current_user.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/keys.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/auth_widgets/blurred_container.dart';

class ActivatePlanNowView extends GetView<PaymentController> {
  final PlanModel plan;
  final String transactionId;

  const ActivatePlanNowView({Key? key, required this.plan, required this.transactionId}) : super(key: key);

  static double getHeight = CurrentUser().currentUser.isFirstTimeBuyer! ? 360 : 450;

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentController());
    return Scaffold(
        backgroundColor: AppColors.homeBGColor,
        body: Stack(
          alignment: Alignment.center,
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
              top: 100,
              child: Image.asset(
                Assets.img_desgin_color,
                fit: BoxFit.fill,
                height: 100,
                width: Dimens.width(100, context),
                alignment: Alignment.topLeft,
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      BlurredContainer(
                          height: Dimens.height(100, context),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 80,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppString().purchase_success(context),
                                    textAlign: TextAlign.left,
                                    style: FontUtils.TTFirsNeueTrial.copyWith(
                                        fontSize: Dimens.currentSize(context, 16, 20, 22),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppString().purchase_success_details(context),
                                    textAlign: TextAlign.start,
                                    style: FontUtils.TTFirsNeueTrial.copyWith(
                                        fontSize: Dimens.currentSize(context, 12, 14, 16),
                                        color: Colors.white,
                                        height: 0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: Dimens.width(100, context),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(25),
                                      color: AppColors.kPurchageDialog),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                              plan.priceBundle != 0.0
                                                  ? "${StringUtils.getCurrencySymbol(plan.currency!)} ${plan.priceBundle!.toPrecision(2)}"
                                                  : plan.price != null && plan.price != 0.0
                                                      ? "${StringUtils.getCurrencySymbol(plan.currency!)} ${plan.price!.toPrecision(2)}"
                                                      : "",
                                              style: FontUtils.TTFirsNeueTrial.copyWith(
                                                fontSize: Dimens.currentSize(context, 28, 32, 34),
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ))),
                                      devider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(AppString().plan_details(context),
                                                style: FontUtils.SF.copyWith(
                                                  fontSize: Dimens.currentSize(context, 10, 12, 14),
                                                  color: AppColors.kHintColor,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            Container(
                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                child: Text(
                                                    "${plan.name!} - ${PlanUtils.totalData(plan)} for ${PlanUtils.getValidity(plan.validity!)}",
                                                    style: FontUtils.SF.copyWith(
                                                      fontSize: Dimens.currentSize(context, 12, 14, 16),
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ))),
                                          ],
                                        ),
                                      ),
                                      CurrentUser().configResponse.data!.rewardPointsEnabled! &&
                                              plan.rewardPointsRedeemed! > 0
                                          ? Column(
                                              children: [
                                                devider(),
                                                _billItem(
                                                    Assets.reward_icon,
                                                    AppString().reward_points(context) +
                                                        " ${plan.rewardPointsRedeemed}(${StringUtils.getCurrencySymbol(plan.currency!)}${plan.rewardCashValueRedeemed!.toPrecision(2)})",
                                                    "-${StringUtils.getCurrencySymbol(plan.currency!)}${plan.rewardCashValueRedeemed!.toPrecision(2)}",
                                                    context),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                      CurrentUser().configResponse.data!.couponCodesMasterEnabled! &&
                                              plan.couponCode != ""
                                          ? Column(
                                              children: [
                                                devider(),
                                                _billItem(
                                                    Assets.coupon_code,
                                                    AppString().coupon_code(context) + " " + plan.couponCode!,
                                                    "-${StringUtils.getCurrencySymbol(plan.currency!)}${plan.couponAmount!.toPrecision(2)}",
                                                    context),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                      CurrentUser().configResponse.data!.rewardPointsEnabled! ||
                                              CurrentUser().configResponse.data!.couponCodesMasterEnabled!
                                          ? Column(
                                              children: [
                                                devider(),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        AppString().amount_payable(context),
                                                        textAlign: TextAlign.left,
                                                        style: FontUtils.SF.copyWith(
                                                            fontSize: Dimens.currentSize(context, 16, 18, 20),
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                      Text(
                                                        "${StringUtils.getCurrencySymbol(plan.currency!)}${plan.price!.toPrecision(2)}",
                                                        textAlign: TextAlign.left,
                                                        style: FontUtils.SF.copyWith(
                                                            fontSize: Dimens.currentSize(context, 24, 26, 28),
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                CurrentUser().configResponse.data!.rewardPointsEnabled!
                                    ? Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: Dimens.width(100, context),
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.circular(18),
                                                color: AppColors.kPurchageDialog),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    AppString().earned_reward_point(context),
                                                    textAlign: TextAlign.left,
                                                    style: FontUtils.SF.copyWith(
                                                        fontSize: Dimens.currentSize(context, 14, 16, 18),
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  const Spacer(),
                                                  SvgPicture.asset(Assets.reward_icon),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "${plan.earnedPoints!}",
                                                    textAlign: TextAlign.left,
                                                    style: FontUtils.SF.copyWith(
                                                        fontSize: Dimens.currentSize(context, 14, 16, 18),
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Obx(
                                  () => Visibility(
                                    replacement: Container(),
                                    visible: !controller.isFirstTimeUser.value,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Obx(
                                          () => ActivationOptionItem(
                                              isSelected: !controller.isManual.value,
                                              label: AppString().active_plan_now(context),
                                              onTap: () => controller.changeActivationOption(false)),
                                        ),
                                        Obx(
                                          () => ActivationOptionItem(
                                              isSelected: controller.isManual.value,
                                              label: AppString().manually_active_later(context),
                                              onTap: () => controller.changeActivationOption(true)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                PrimaryActionButton(
                                    label: AppString().continue_key(context),
                                    onTap: () => controller.continueAhead(plan, transactionId),
                                    isLoading: false),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 120,
              child: Image.asset(
                Assets.payment_success,
                fit: BoxFit.fill,
                height: 170,
                width: 170,
                alignment: Alignment.topLeft,
              ),
            ),
          ],
        ));
  }
}

Widget _billItem(String icon, String title, String amount, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 16,
              width: 16,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.left,
              style: FontUtils.SF.copyWith(
                  fontSize: Dimens.currentSize(context, 12, 14, 18), color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Text(
          amount,
          textAlign: TextAlign.left,
          style: FontUtils.SF.copyWith(
              fontSize: Dimens.currentSize(context, 12, 16, 18), color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

Widget devider() {
  return Container(color: AppColors.kHintColor, height: 1);
}

class ActivationOptionItem extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const ActivationOptionItem({Key? key, required this.isSelected, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: onTap,
            icon:
                Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: AppColors.bgButtonColor)),
        const SizedBox(width: 10),
        Text(
          label,
          style: FontUtils.SF.copyWith(
              fontSize: Dimens.currentSize(context, 14, 16, 18), color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class eSimViewOptionItem extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const eSimViewOptionItem({Key? key, required this.isSelected, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: FontUtils.SF.copyWith(
                fontSize: Dimens.currentSize(context, 12, 14, 16), color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: onTap,
            icon:
                Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: AppColors.bgButtonColor)),
        const SizedBox(width: 15),
      ],
    );
  }
}
